class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

   has_many :access_grants,
            class_name: 'Doorkeeper::AccessGrant',
            foreign_key: :resource_owner_id,
            dependent: :destroy

   has_many :access_tokens,
            class_name: 'Doorkeeper::AccessToken',
            foreign_key: :resource_owner_id,
            dependent: :destroy

  before_create :assign_public_id
  after_create :notify_create
  after_update :notify_update

  delegate :admin?, to: :role

  def role
    super.inquiry
  end

  def notify_create
    payload = { event_name: 'AccountCreated', data: event_data }
    Event.new(payload).produce('accounts-stream')
  end

  private

  def assign_public_id
    self.public_id = SecureRandom.uuid if public_id.blank?
  end

  def notify_update
    payload = { event_name: 'AccountUpdated', data: event_data }
    Event.new(payload).produce('accounts-stream')
  end

  def event_data
    as_json(only: %w[email public_id role name])
  end
end
