class ApplicationBilling
  Error = Class.new StandardError

  def initialize(product:, account:)
    @product = product
    @account = account
  end

  def process!
    create_and_share_transaction
    update_account_balance
  end

  private

  def create_and_share_transaction
    transaction = Transaction.create!(
      account: account,
      product: product,
      transaction_type: transaction_type,
      amount: price
    )
    share_transaction(transaction)
  end

  def share_transaction(transaction)
    Event.new(transaction).produce(action: :created)
  end

  def update_account_balance
    system_action = transaction_type.to_s.inquiry
    if system_action.debit?
      account.reduce_balance(price)
    elsif system_action.credit?
      account.increase_balance(price)
    else
      raise Error, "Unknown system action #{system_action}"
    end
  end

  attr_reader :product, :account
  delegate :price, :transaction_type, to: :product
end
