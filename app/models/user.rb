# User model with devise authentication
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         password_length: 6..128

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

  validate :min_password_length

  has_many :products
  belongs_to :role

  before_create :set_default_role

  private

  def set_default_role
    self.role ||= Role.find_by_name('guest')
  end

  def min_password_length
    case self.role
    when Role.find_by_name('guest')
      errors.add(:password, 'min length is 6') if password.length < 6
    when Role.find_by_name('owner')
      errors.add(:password, 'min length is 8') if password.length < 8
    when Role.find_by_name('admin')
      errors.add(:password, 'min length is 10') if password.length < 10
    end
  end
end
