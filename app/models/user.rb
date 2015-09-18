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
  validates_attachment_content_type :avatar, content_type: %r/\Aimage\/.*\Z/
  validates_attachment_size :avatar, less_than: 4.megabytes

  # Admin passport
  has_attached_file :passport,
                    styles: { medium: '450x450>', thumb: '100x100#' },
                    default_url: '/images/:style/missing.png',
                    url: '/images/:hash.:extension',
                    hash_secret: 'da9a3c0d2aaf25d6bb627051fd2cf9a4'
  validates_attachment_content_type :passport, content_type: %r/\Aimage\/.*\Z/
  validates_attachment_size :passport, less_than: 4.megabytes

  # Validations for different user roles
  validate :password_length
  validates :name, presence: true, if: -> { role.name == 'admin' }
  validates :avatar, presence: true,
            if: -> { %w(admin owner).include? role.name }
  validates :passport, presence: true, if: -> { role.name == 'admin' }
  validates :birthdate, presence: true, if: -> { role.name == 'admin' }

  has_many :products
  belongs_to :role
  has_one :store

  before_validation :set_default_role, on: :create

  def store_name=(name)
    create_store(name: name) unless store
    store.name = name if store
  end

  def store_name
    store.name if store
  end

  private

  def set_default_role
    self.role ||= Role.find_by_name('guest')
  end

  def password_length
    # TODO: move minimum password length to database
    roles = { 'guest' => 6, 'owner' => 8, 'admin' => 10 }
    errors.add(
      :password,
      "min length is #{roles[role.name]}"
    ) if password.length < roles[role.name]
  end
end
