# Preform placing order in background
class PlaceOrderJob < ActiveJob::Base
  queue_as :default

  def perform(user, product)
    photo = retrieve_photo

    photo_file = retrieve_photo_file photo
    UserMailer.order_placed_email(user, product, photo_file)
      .deliver_later if photo_ok? photo
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
    HTTParty.get(photo['url']).body
  end
end
