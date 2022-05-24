class Task < ApplicationRecord
  STATUSES = %w[in_progress completed].freeze

  validates :title, :status, presence: true
  validates :status, inclusion: STATUSES
  scope :in_progress, -> { where(status: :in_progress) }
  scope :completed, -> { where(status: :completed) }

  belongs_to :account
  before_validation :assign_status

  delegate :in_progress?, to: :status

  def account_assign
    account.human_id
  end

  def complete!
    update!(status: :completed)
  end

  def status
    super.inquiry
  end

  def belongs_to?(account_to_check)
    account.id == account_to_check.id
  end

  private

  def assign_status
    self.status ||= 'in_progress'
  end

  def nofify_assign
  end
end
