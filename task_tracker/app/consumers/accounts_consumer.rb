# frozen_string_literal: true

class AccountsConsumer < ApplicationConsumer
  def consume
    payload = params.payload.deep_symbolize_keys
    case payload[:name]
    when "AccountCreated" then create_or_update_account!(payload[:data])
    when "AccountUpdated" then create_or_update_account!(payload[:data])
    else
      raise Error, "Undefined event received #{payload[:name]}"
    end
  end

  private

  def update_account!(account_params)
    account = Account.find_or_initialize_by(public_id: account_params[:public_id])
    account.update!(account_params)
  end
end
