class ApplicationBilling
  def initialize(product:, account:)
    @product = product
    @account = account
  end

  def process!
    Transaction.create!(
      account: account,
      product: product,
      transaction_type: product.transaction_type,
      amount_cents: product.price_cents,
    )
  end

  private

  attr_reader :product, :account
end
