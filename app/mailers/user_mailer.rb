class UserMailer < ActionMailer::Base
  default :from => "autoresponder.szs@agh.edu.pl"

  include Resque::Mailer

  layout 'diamond/default_mailer'

  def deliver_password_reset_instructions(user_id)
    @user = User.find_by_id(user_id)

    mail(:to => @user.email,
         :subject => "#{Settings.app_name} - #{I18n.t(:mail_subject_password_reset_instructions)}")
  end

  def students_list_upgrade_failed(user_id, failure_message)
    @user = User.find_by(:id => user_id)
    @failure_message = failure_message

    mail(:to => @user.email,
         :subject => "#{Settings.app_name} - #{I18n.t(:mail_subject_students_list_upgrade_failed)}")
  end

  def students_list_upgrade_succeseed(user_id)
    @user = User.find_by(:id => user_id)

    mail(:to => @user.email,
         :subject => "#{Settings.app_name} - #{I18n.t(:mail_subject_students_list_upgrade_succeseed)}")
  end



end
