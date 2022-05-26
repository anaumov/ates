class Account < ApplicationRecord
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

  ROLES = %w[admin employee].freeze
  validates :email, :role, presence: true
  validates :role, inclusion: ROLES

  before_validation :assign_password
  before_create :assign_public_id
  after_create :notify_create
  after_update :notify_update

  delegate :admin?, :employee?, to: :role

  def role
    super.inquiry
  end

  def notify_create
    Event.new(self).produce(action: :created)
  end

  def event_data
    as_json(only: %w[email public_id role name])
  end

  private

  def assign_password
    self.password ||= Devise.friendly_token
  end

  def assign_public_id
    self.public_id = SecureRandom.uuid if public_id.blank?
  end

  def notify_update
    Event.new(self).produce(action: :updated)
  end
end
