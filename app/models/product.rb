# Simple product model. Products has name, description and photo
class Product < ActiveRecord::Base
  belongs_to :user

  validates :name, presence: true, length: { maximum: 42 }
  validates :photo, presence: true, on: :create
  validates :user, presence: true

  has_attached_file :photo, styles: { medium: '450x450>', thumb: '100x100#' },
                            default_url: '/images/:style/missing.png',
                            url: '/images/:hash.:extension',
                            hash_secret: 'da9a3c0d2aaf25d6bb627051fd2cf9a4'
  validates_attachment_content_type :photo, content_type: %r{/\Aimage\/.*\Z/}
  validates_attachment_size :photo, less_than: 4.megabytes
end
