class Transaction < ApplicationRecord
  TYPES = %w[debit credit].freeze
  monetize :amount_cents
  validates :transaction_type, :amount_cents, :public_id, presence: true

  validates :transaction_type, inclusion: TYPES
  delegate :public_id, to: :account, prefix: true

  belongs_to :account
end
