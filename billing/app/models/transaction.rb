class Transaction < ApplicationRecord
  TYPES = %w[debit credit].freeze
  monetize :amount_cents
  validates :transaction_type, :amount_cents, presence: true

  validates :transaction_type, inclusion: TYPES

  belongs_to :account
  belongs_to :product
end
