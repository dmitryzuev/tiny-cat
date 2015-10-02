# Process orders
class OrderService
  def initialize(user, product)
    @user = user
    @product = product

    perform
  end

  def perform
    photo = retrieve_photo
    photo_file = retrieve_photo_file photo

    unless photo_ok? photo
      AdminMailer.order_failed_email(@user).deliver_now
      fail 'Ошибка при покупке. Попробуйте еще раз.'
    end

    UserMailer.order_placed_email(@user, @product, photo_file).deliver_now

    todo_id = retrieve_todo
    AdminMailer.order_placed_email(todo_id).deliver_now
  end

  private

  # Random delay
  def make_delay
    delay = rand 0.0..6.0
    sleep (delay < 3) ? delay : 3

    delay < 3
  end

  def retrieve_photo
    # Check for too long delay
    unless make_delay
      fail 'Слишком долгое ожидание сервиса.'
    end

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
    3.times do
      if make_delay
        return HTTParty.post('http://jsonplaceholder.typicode.com/todos')['id']
      end
    end
    AdminMailer.order_too_long_email.deliver_now
    fail 'Слишком долгое ожидание сервиса.'
  end
end
