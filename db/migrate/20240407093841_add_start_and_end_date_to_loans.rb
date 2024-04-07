class AddStartAndEndDateToLoans < ActiveRecord::Migration[7.0]
  def change
    add_column :loans, :start_date, :datetime
    add_column :loans, :end_date, :datetime
  end
end
