class AddTotalAmountToLoans < ActiveRecord::Migration[7.0]
  def change
    add_column :loans, :total_amount, :decimal, precision: 15, scale: 2
  end
end
