class User < ActiveRecord::Base

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
  belongs_to :verifable, :polymorphic => true, :dependent => :destroy
  belongs_to :employee, :foreign_key => :verifable_id, :class_name => "Employee"
  belongs_to :student, :foreign_key => :verifable_id, :class_name => "Student"
  belongs_to :language, :class_name => "Language"

  serialize :preferences, Hash

  cattr_accessor :current

  def blocked?
    self.status == STATUS_BLOCKED
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

  %w{employee student}.each do |mod|
    define_method "#{mod}?" do
      verifable_type == mod.classify
    end
  end

end
