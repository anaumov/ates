# frozen_string_literal: true

class AccountsConsumer < ApplicationConsumer
  def consume
    payload = params.payload.deep_symbolize_keys
    case payload[:name]
    when "AccountCreated" then create_account!(payload[:data])
    when "AccountUpdated" then update_account!(payload[:data])
    else
      raise Error, "Undefined event received #{payload[:name]}"
    end
  end

  private

  def create_account!(account_params)
    # Account.create!(account_params)
  end

  def update_account!(account_params)
    account = Account.find_by!(public_id: account_params[:public_id])
    account.update!(account_params)
  end
end

#<Karafka::Params::Params:0x0000000125974bb0>
