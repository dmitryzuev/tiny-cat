# Preform placing order in background
class PlaceOrderJob < ActiveJob::Base
  queue_as :default

  rescue_from(RuntimeError) do |error|
    retry_job wait: 5.minutes
  end

  def perform(user, product, attempt = 1)
    delay = rand 0.0..6.0

    sleep 3 && fail 'get_error' if rand > 3
    sleep delay
    photo = retrieve_photo
    photo_file = retrieve_photo_file photo
    
    UserMailer.order_placed_email(user, product, photo_file)
      .deliver_now if photo_ok? photo
    AdminMailer.order_failed_email(user)
      .deliver_now unless photo_ok? photo

    3.times do |i|
      delay = rand 3.0..6.0
      fail 'post_error' if delay > 3 && i == 2
      break unless delay > 3
    end

    sleep delay
    todo_id = retrieve_todo

    AdminMailer.order_placed_email(todo_id)
      .deliver_now if photo_ok? photo
  end

  def retrieve_photo
    HTTParty.get('http://jsonplaceholder.typicode.com/photos/').sample
  end

  def photo_ok?(photo)
    return true if photo['url'].split('/').last.to_i(16) >
                   photo['thumbnailUrl'].split('/').last.to_i(16)
    false
  end

  def retrieve_photo_file(photo)
    HTTParty.get(photo['url']).parsed_response
  end

  def retrieve_todo
    HTTParty.post('http://jsonplaceholder.typicode.com/todos')['id']
  end
end
