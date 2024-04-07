class Wallet < ApplicationRecord
  belongs_to :wallet_user, polymorphic: true
end
