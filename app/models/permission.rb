class Permission < ActiveRecord::Base

  has_many :permission_roles
  has_many :roles, :through => :permission_roles

  def cannot?
    cannot.present?
  end

end
