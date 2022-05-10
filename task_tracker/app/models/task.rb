class Task < ApplicationRecord
  scope :in_progress, -> { where(status: :in_progress) }

  belongs_to :account

  def account_assign
    account.name
  end
end
