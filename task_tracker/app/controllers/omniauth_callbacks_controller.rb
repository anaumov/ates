class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token

  def doorkeeper
    account = Account.from_omniauth(request.env["omniauth.auth"])

    if account.persisted?
      account.update_doorkeeper_credentials(request.env["omniauth.auth"])
      sign_in_and_redirect account, event: :authentication
      set_flash_message(:notice, :success, kind: "Doorkeeper") if is_navigational_format?
    else
      session["devise.doorkeeper_data"] = request.env["omniauth.auth"]
      redirect_to new_account_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end
