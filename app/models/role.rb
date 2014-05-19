class Role < ActiveRecord::Base

  has_many :users
  has_many :permission_roles
  has_many :permissions, :through => :permission_roles

  translates :name

  scope :visible, -> { where(:visible => true) }
  scope :except_role, ->(const_name) { where("const_name NOT IN (?)", const_name) }

  def <=>(other)
    name <=> other.name
  end

end
