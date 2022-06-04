# frozen_string_literal: true

class Account < ApplicationRecord
  monetize :balance_cents
  devise :omniauthable, omniauth_providers: %i[doorkeeper]
  validates_uniqueness_of :email, allow_blank: true

  delegate :admin?, to: :role

  scope :employee, -> { where(role: :employee) }
  scope :with_positive_balance, -> { where('balance_cents > ?', 0) }

  def role
    super.inquiry
  end

  def human_id
    [name, email].compact.join(' — ')
  end

  def self.from_omniauth(auth)
    where(public_id: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.name = auth.info.name
      user.role = auth.info.role
    end
  end

  def update_doorkeeper_credentials(auth)
    update(
      doorkeeper_access_token: auth.credentials.token,
      doorkeeper_refresh_token: auth.credentials.refresh_token
    )
  end

  def wallet
    SecureRandom.uuid
  end

  def increase_balance(amount)
    update(balance: balance + amount)
  end

  def reduce_balance(amount)
    update(balance: balance - amount)
  end
end
