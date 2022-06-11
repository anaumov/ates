class Transaction < ApplicationRecord
  TYPES = %w[debit credit].freeze
  monetize :amount_cents
  validates :transaction_type, :amount_cents, :public_id, presence: true

  validates :transaction_type, inclusion: TYPES
  delegate :public_id, to: :account, prefix: true

  scope :today, -> { where(created_at: Time.zone.now.all_day) }
  scope :week, -> { where(created_at: Time.zone.now.all_week) }
  scope :month, -> { where(created_at: Time.zone.now.all_month) }
  scope :debit, -> { where(transaction_type: :debit) }
  scope :credit, -> { where(transaction_type: :credit) }
  scope :completed_tasks, -> { credit.where(product_type: :task) }

  belongs_to :account
end
