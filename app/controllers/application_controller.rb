class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    logger.error "[cancan] Access denied, message: #{exception.message}"
    redirect_to root_url, :alert => exception.message
  end

  protected

  def authenticate_inviter!
    if authorize! :invite, User
      current_user
    end
  end

end
