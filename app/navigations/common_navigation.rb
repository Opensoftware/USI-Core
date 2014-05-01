if defined?(current_user)
  SimpleNavigation::Configuration.run do |navigation|
    navigation.items do |primary|
      primary.dom_class = 'nav navbar-nav'
      if current_user
        if session[:usi_sd]
          primary.item :logout, t(:label_logout), main_app.back_to_user_sessions_path
        end
        primary.item :user_account, "#{t(:label_account_my)}", main_app.user_path(current_user)
        primary.item :user_email, current_user.email, main_app.root_path, :id => "user_email"
        unless session[:usi_sd]
          primary.item :logout, t(:label_logout), main_app.logout_path, method: :delete
        end
      else
        primary.item :login, I18n.t(:label_login), main_app.new_user_session_path
      end
    end
  end
end
