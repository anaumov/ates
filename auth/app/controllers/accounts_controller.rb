class AccountsController < ApplicationController
  before_action :authenticate_user!, except: %w[current]

  def new
    @account = Account.new(email: generate_email)
  end

  def edit
  end

  def create
    @account = Account.new(account_params)

    if @account.save
      redirect_to accounts_url, notice: "Задача создана"
    else
      render :new, status: :unprocessable_entity
    end
  end

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

  def generate_email
    domains = %w[gmail.com outlook.com mail.ru yahoo.com aol.com]
    "#{SecureRandom.hex[0..6]}@#{domains.sample}"
  end

  def account_from_token
    Account.find(doorkeeper_token.resource_owner_id)
  end

  def account
    @account ||= Account.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:name, :role, :email)
  end
end
