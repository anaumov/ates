class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_create :assign_public_id

  private

  def assign_public_id
    self.public_id = SecureRandom.uuid if public_id.blank?
  end
end
