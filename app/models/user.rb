class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :loans, dependent: :destroy
  has_one :wallet, as: :wallet_user, dependent: :destroy

  after_create :create_user_wallet

  private

  def create_user_wallet
    create_wallet(amount: 10000)
  end
end
