# Basic user roles
class Role < ActiveRecord::Base
  has_many :users
end
