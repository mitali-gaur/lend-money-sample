class CreateLoans < ActiveRecord::Migration[7.0]
  def change
    create_table :loans do |t|
      t.decimal :amount, precision: 9, scale: 2
      t.integer :state, default: 0
      t.integer :interest_rate_in_percentage, default: 5
      t.references :user

      t.timestamps
    end
  end
end
