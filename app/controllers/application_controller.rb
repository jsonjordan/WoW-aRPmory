class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ActionController::InvalidAuthenticityToken, 
    with: :handle_invalid_token


  def handle_invalid_token
    redirect_back fallback_location: character_select_path(current_user.no_hash_battletag), 
      alert: 'Known bug, please try selecting your characters again.'
  end

  def bulk_push
    begin
      User.send_bulk_notifications(params[:message])
      redirect_to admin_notification_path, notice: "Insufficient rights!"
    rescue
      redirect_to admin_notification_path, alert: "Error"
    end
  
  end
  
end
