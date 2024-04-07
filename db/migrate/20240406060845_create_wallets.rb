class CreateWallets < ActiveRecord::Migration[7.0]
  def change
    create_table :wallets do |t|
      t.decimal :amount, precision: 9, scale: 2
      t.references :wallet_user, polymorphic: true
      t.timestamps
    end
  end
end
