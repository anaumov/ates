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
    transaction = Transaction.find_or_initialize_by(public_id: transaction_params[:public_id])
    transaction_params_with_account = add_account_id(transaction_params)
    transaction.update!(transaction_params_with_account)
  end

  def add_account_id(params)
    account = Account.find_or_create_by(public_id: params.delete(:account_public_id))
    params.merge(account_id: account.id)
  end
end
