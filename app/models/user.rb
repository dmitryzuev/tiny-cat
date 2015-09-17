# User model with devise authentication
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Admin and Owner avatars
  has_attached_file :avatar, styles: { medium: '450x450>', thumb: '100x100#' },
                             default_url: '/images/:style/missing.png',
                             url: '/images/:hash.:extension',
                             hash_secret: 'da9a3c0d2aaf25d6bb627051fd2cf9a4'
  validates_attachment_content_type :avatar, content_type: %r{/\Aimage\/.*\Z/}
  validates_attachment_size :avatar, less_than: 4.megabytes

  # Admin passport
  has_attached_file :passport,
                    styles: { medium: '450x450>', thumb: '100x100#' },
                    default_url: '/images/:style/missing.png',
                    url: '/images/:hash.:extension',
                    hash_secret: 'da9a3c0d2aaf25d6bb627051fd2cf9a4'
  validates_attachment_content_type :avatar, content_type: %r{/\Aimage\/.*\Z/}
  validates_attachment_size :avatar, less_than: 4.megabytes

  has_many :products
  belongs_to :role

  before_create :set_default_role

  private

  def set_default_role
    self.role ||= Role.find_by_name('guest')
  end
end
