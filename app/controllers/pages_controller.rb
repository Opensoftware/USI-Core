class PagesController < ApplicationController
  before_action :login_required
  before_action :role_required

  def index
    render :text => 'index'
  end
end
