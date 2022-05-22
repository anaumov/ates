class AccountsController < ApplicationController
  before_action :authenticate_account!, only: [:index]

  # GET /accounts
  # GET /accounts.json
  def index
    @accounts = Account.all
  end

  def edit
    render locals: { account: account }
  end

  def update
    account.update!(account_params)
    redirect_to accounts_path
  rescue ActiveRecord::RecordInvalid => e
    render :edit, locals: { account: e.record }
  end

  def current
    render json: account_from_token
  end

  private

  def account_from_token
    Account.find(doorkeeper_token.resource_owner_id)
  end

  def account
    @account ||= Account.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:name, :role)
  end
end
