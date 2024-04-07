class AddUpdatedInterestDatetimeToLoans < ActiveRecord::Migration[7.0]
  def change
    add_column :loans, :updated_interest_datetime, :datetime
  end
end
