class CreateLoanConfirmationRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :loan_confirmation_requests do |t|
      t.integer :state, default: 0
      t.integer :interest_rate, default: 5
      t.references :loan

      t.timestamps
    end
  end
end
