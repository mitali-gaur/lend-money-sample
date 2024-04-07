class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  has_one :wallet, as: :wallet_user, dependent: :destroy

  after_create :create_admin_wallet

  private

  def create_admin_wallet
    create_wallet(amount: 1000000)
  end
end
