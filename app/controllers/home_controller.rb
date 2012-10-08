class HomeController < ApplicationController
  def index
    [:alert, :error, :notice, :info].each{|m| flash[m] = flash[m] if flash[m]}
    if user_signed_in?
      redirect_to declarations_path
    else
      redirect_to new_user_session_path
    end
  end
end
