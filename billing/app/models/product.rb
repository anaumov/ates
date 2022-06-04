class Product < ApplicationRecord
  TRANSACTIONS_TYPES = %w[debit credit].freeze
  monetize :price_cents
  validates :name, :product_type, :product_public_id, :transaction_type, presence: true
  validates :transaction_type, inclusion: TRANSACTIONS_TYPES

  before_validation :preset_defaults

  private

  def preset_defaults
    self.product_public_id ||= SecureRandom.uuid

    case name
    when 'TaskAssignment'
      self.price ||= Money.from_amount(rand(10..20))
      self.transaction_type ||= 'debit'
    when 'TaskCompletion'
      self.price ||= Money.from_amount(rand(20..40))
      self.transaction_type ||= 'credit'
    when 'AccountPayout'
      self.transaction_type ||= 'credit'
    else raise "Unknown product name: #{name}"
    end
  end
end
