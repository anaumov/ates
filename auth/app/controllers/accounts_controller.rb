class AccountsController < ApplicationController
  before_action :authenticate_account!, only: [:index]

  # GET /accounts
  # GET /accounts.json
  def index
    @accounts = Account.all
  end

  def current
    render json: account_from_token
  end

  private

  def account_from_token
    Account.find(doorkeeper_token.resource_owner_id)
  end
end
