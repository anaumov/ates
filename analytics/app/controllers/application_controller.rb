class ApplicationController < ActionController::Base

  def authorize_admin!
    render text: "Только для админов", status: :forbidden unless current_user.admin?
  end
end
