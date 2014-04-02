class UserSession < Authlogic::Session::Base

  consecutive_failed_logins_limit 5
  # TODO think about removing timeout or make it optional with possibility to
  # set value, with hight default value smth like 40 minutes.
  self.logout_on_timeout = true unless Rails.env.development?
  before_validation :check_status

  def check_status
    if email
      user = User.where(:email => email).first
      if user
        errors.add(:base, I18n.t(:notice_account_is_blocked, :admin => user.verifable.try(:academy_unit).try(:name))) if user.blocked?
        errors.add(:base, I18n.t(:notice_account_is_not_active, :admin => user.verifable.try(:academy_unit).try(:name))) if user.not_active?
      else
        errors.add(:base, I18n.t(:notice_account_not_exists))
      end
    end
  end
end
