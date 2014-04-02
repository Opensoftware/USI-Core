UsiCore::Application.routes.draw do

  scope "(:locale)", :locale => /pl|en/ do
    root 'base#index'

    resources :dashboard, :only => :index

    # authorization module
    resources :user_sessions do
      collection do
        get "sudo_su/:user_id", :action => "sudo_su" , :as => "sudo_su"
        get "back_to_su", :as => "back_to"
      end
    end
    match "login"  => "user_sessions#new", via: :get
    match "logout" => "user_sessions#destroy", via: :delete
    match "register" => "users#create", via: :post
    match "signup" => "users#new", via: :get
    resources :users do
      member do
        post :accept
        post :block
        post :unlock
      end
    end
  end
end
