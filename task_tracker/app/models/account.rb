class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :omniauthable, omniauth_providers: %i[doorkeeper]
  validates_uniqueness_of :email, allow_blank: true

  delegate :admin?, to: :role
  has_many :tasks

  scope :employee, -> { where(role: :employee) }

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
end
