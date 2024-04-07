class AddNotesToLoans < ActiveRecord::Migration[7.0]
  def change
    add_column :loans, :notes, :string
  end
end
