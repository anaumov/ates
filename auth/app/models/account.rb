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

  delegate :admin?, to: :role

  def role
    super.inquiry
  end

  private

  def assign_public_id
    self.public_id = SecureRandom.uuid if public_id.blank?
  end
end
