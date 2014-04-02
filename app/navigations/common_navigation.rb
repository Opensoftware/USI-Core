SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.dom_class = 'nav navbar-nav'
    if current_user
      if session[:usi_sd]
        primary.item :logout, t(:label_logout), back_to_user_sessions_path
      end
      primary.item :user_account, "#{t(:label_account_my)}", user_path(current_user)
      primary.item :user_email, current_user.email, root_path, :id => "user_email"
      unless session[:usi_sd]
        primary.item :logout, t(:label_logout), logout_path, method: :delete
      end
    else
      primary.item :login, t(:label_login), new_user_session_path
    end
  end

end
