# frozen_string_literal: true

class TransactionsConsumer < ApplicationConsumer
  def consume
    payload = params.payload.deep_symbolize_keys
    case payload[:name]
    when "TransactionCreated" then create_transaction!(payload[:data])
    else
      raise Error, "Undefined event received #{payload[:name]}"
    end
  end

  private

  def create_transaction!(transaction_params)
    account = Transaction.find_or_initialize_by(public_id: transaction_params[:public_id])
    account.update!(transaction_params)
  end
end
