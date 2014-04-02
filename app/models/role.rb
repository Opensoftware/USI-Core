class Role < ActiveRecord::Base

  has_many :users
  has_many :permission_roles
  has_many :permissions, :through => :permission_roles

  translates :name
end
