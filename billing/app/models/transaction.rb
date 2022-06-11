class Transaction < ApplicationRecord
  TYPES = %w[debit credit].freeze
  monetize :amount_cents
  validates :transaction_type, :amount_cents, :public_id, presence: true

  validates :transaction_type, inclusion: TYPES
  delegate :public_id, to: :account, prefix: true
  delegate :product_type, to: :product

  belongs_to :account
  belongs_to :product

  before_validation :set_public_id

  def event_data
    as_json(
      only: %w[public_id amount_cents transaction_type created_at],
      methods: %w[account_public_id product_type]
    )
  end

  private

  def set_public_id
    self.public_id ||= SecureRandom.uuid
  end
end
