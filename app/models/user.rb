class User < ActiveRecord::Base

  extend Forwardable

  def_delegator :verifable, :surname_name

  STATUS_ACTIVE = 1
  STATUS_NOT_ACTIVE = 0
  STATUS_BLOCKED = -1
  STATUS = {:active => STATUS_ACTIVE, :not_active => STATUS_NOT_ACTIVE, :blocked => STATUS_BLOCKED}

  acts_as_authentic do |c|
    c.login_field = :email
    c.logged_in_timeout(90.minutes)
    c.crypto_provider = Authlogic::CryptoProviders::Sha512
  end

  validates_uniqueness_of :email, :scope => [:verifable_type]
  validates_presence_of :role_id
  belongs_to :role
  belongs_to :verifable, :polymorphic => true
  belongs_to :employee, :foreign_key => :verifable_id, :class_name => "Employee"
  belongs_to :student, :foreign_key => :verifable_id, :class_name => "Student"
  belongs_to :language, :class_name => "Language"

  serialize :preferences, Hash

  cattr_accessor :current

  def deliver_password_reset_instructions!
    reset_perishable_token!
    UserMailer.deliver_password_reset_instructions(self.id).deliver
  end

  def blocked?
    self.status == STATUS_BLOCKED || failed_logins_exceeded?
  end

  def active?
    self.status == STATUS_ACTIVE
  end

  def not_active?
    self.status == STATUS_NOT_ACTIVE
  end

  def silent_activate!
    self.status = STATUS_ACTIVE
    self.save!
  end

  def failed_logins_exceeded?
    self.failed_login_count.to_i >= 5
  end

  def deactivate!
    self.status = STATUS_BLOCKED
    self.save
  end

  def unlock!
    self.failed_login_count = 0
    self.status = STATUS_ACTIVE
    self.save
  end

  %w{employee student}.each do |mod|
    define_method "#{mod}?" do
      verifable_type == mod.classify
    end
  end

  %w{anonymous department_admin admin superadmin supervisor}.each do |role|
    define_method "#{role}?" do
      self.role.const_name == role
    end
  end

end
