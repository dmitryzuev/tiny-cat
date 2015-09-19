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
  validate :password_length_on_create, on: [:create]
  validate :password_length_on_update, on: [:update]
  validates :name, presence: true, if: :is_admin?
# FIXME: Not working avatar for 'owner' roles
#  validates :avatar, presence: true,
#            if: -> { %w(admin owner).include? role.name }
#  validates :avatar, attachment_presence: true,
#            if: -> { %w(admin owner).include? Role.find_by(id: role_id) }
  validates :avatar, attachment_presence: true, if: :is_owner?
  validates :avatar, attachment_presence: true, if: :is_admin?
  validates :passport, attachment_presence: true, if: :is_admin?
  validates :birthdate, presence: true, if: :is_admin?
  validates :store_name, presence: true, if: :is_owner?

  has_many :products
  belongs_to :role

  before_validation :set_default_role, on: :create

  private

  def is_owner?
    Role.find_by(role_id).name == 'owner'
  end

  def is_admin?
    Role.find_by(role_id).name == 'admin'
  end

  def is_guest?
    Role.find_by(role_id).name == 'guest'
  end

  def set_default_role
    self.role ||= Role.find_by_name('guest')
  end

  def password_length_on_create
    # TODO: move minimum password length to database
    roles = { 'guest' => 6, 'owner' => 8, 'admin' => 10 }
    errors.add(
      :password,
      "min length is #{roles[role.name]}"
    ) if password.length < roles[role.name]
  end

  def password_length_on_update
    # TODO: move minimum password length to database
    roles = { 'guest' => 6, 'owner' => 8, 'admin' => 10 }
    errors.add(
        :password,
        "min length is #{roles[role.name]}"
    ) if password.present? &&  password.length < roles[role.name]
  end
end
