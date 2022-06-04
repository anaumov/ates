class ApplicationDailyPayout
  def self.process!
    new.process!
  end

  def process!
    Account.with_positive_balance.each(&method(:make_payout))
  end

  private

  def make_payout(account)
    amount = account.balance
    result = payout_adapter.make_payout(wallet: account.wallet, amount: amount)
    if result.success?
      track_payout(account)
      notify_user(account)
    else
      notify_managment_about_fail
    end
  end

  def track_payout(account)
    product = create_product(account)
    ApplicationBilling.new(product: product, account: account).process!
  end

  def create_product(account)
    Product.create!(
      product_type: :account_payout,
      price: account.balance,
      name: "AccountPayout",
      product_public_id: account.public_id
    )
  end

  def notify_user(account)
    puts "Sending payout email to #{account.email}"
  end

  def notify_managment_about_fail
    puts "Sending report to support@popuguber.com"
  end

  def payout_adapter
    @payout_adapter ||= FakePayoutAdapter.new
  end
end
