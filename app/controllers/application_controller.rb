class ApplicationController < ActionController::Base

  before_action :authenticate_admin!

  protect_from_forgery with: :exception

  def authenticate_admin!
    unless admin_signed_in?
      # check if it's login page
      if "#{params[:controller]}/#{params[:action]}".eql?('admins/sessions/create')
        flash[:error] = t('devise.failure.unauthenticated')
      end
      redirect_to new_admin_session_path and return
    end

    session[:user_id] = current_admin.id
  end

end
