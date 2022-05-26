class Task < ApplicationRecord
  STATUSES = %w[in_progress completed].freeze

  validates :title, :status, presence: true
  validates :status, inclusion: STATUSES
  scope :in_progress, -> { where(status: :in_progress) }
  scope :completed, -> { where(status: :completed) }

  belongs_to :account
  before_validation :preset_defaults
  after_create :notify_added

  delegate :in_progress?, to: :status
  delegate :public_id, to: :account, prefix: true

  def account_assign
    account.human_id
  end

  def status
    super.inquiry
  end

  def belongs_to?(account_to_check)
    account.id == account_to_check.id
  end

  def event_data
    as_json(only: %w[account_public_id public_id title status])
  end

  def assign!(account)
    update(account: account)
    notify_assigned
  end

  def complete!
    update(status: :completed)
    notify_completed
  end

  private

  def preset_defaults
    self.status ||= 'in_progress'
    self.public_id ||= SecureRandom.uuid
  end

  def notify_added
    Event.new(self).produce(action: :added)
  end

  def notify_assigned
    Event.new(self).produce(action: :assigned)
  end

  def notify_completed
    Event.new(self).produce(action: :completed)
  end
end
