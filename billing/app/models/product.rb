class Product < ApplicationRecord
  TRANSACTIONS_TYPES = %w[debit credit].freeze
  monetize :price_cents
  validates :name, :product_type, :product_public_id, :transaction_type, presence: true
  validates :transaction_type, inclusion: TRANSACTIONS_TYPES

  before_validation :set_price_and_transaction_type

  private

  def set_price_and_transaction_type
    case name
    when 'TaskAssignment'
      self.price ||= Money.from_amount(rand(10..20))
      self.transaction_type ||= 'credit'
    when 'TaskCompletion'
      self.price ||= Money.from_amount(rand(20..40))
      self.transaction_type ||= 'debit'
    else raise "Unknown product name: #{name}"
    end
  end
end
