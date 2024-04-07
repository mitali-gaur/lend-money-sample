class Loan < ApplicationRecord
  enum state: [:requested, :approved, :open, :closed, :rejected]

  validates :amount, :user, :state, :interest_rate_in_percentage, presence: true

  belongs_to :user
  has_one :loan_confirmation_request, dependent: :destroy

  default_scope -> { order(created_at: :desc) }
  scope :requests, -> { where(state: [:requested, :approved, :rejected]) }

  after_create :set_total_amount

  def self.ransackable_attributes(auth_object = nil)
    ["amount", "created_at", "id", "interest_rate_in_percentage", "state", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end

  def start_loan!
    ActiveRecord::Base.transaction do
      loan_confirmation_request.confirmed!
      update(
        state: 'open', start_date: DateTime.now.utc, interest_rate_in_percentage: loan_confirmation_request.interest_rate
      )
      admin = AdminUser.last
      admin.wallet.update(amount: admin.wallet.amount.to_f - amount.to_f)
      user.wallet.update(amount: user.wallet.amount.to_f + amount.to_f)
    end
  end

  def reject_loan!
    ActiveRecord::Base.transaction do
      rejected!
      loan_confirmation_request.rejected!
    end
  end

  def repay_loan!
    ActiveRecord::Base.transaction do
      update(state: 'closed', end_date: DateTime.now.utc, notes: 'Loan paid')
      admin = AdminUser.last
      admin.wallet.update(amount: admin.wallet.amount.to_f + total_amount.to_f)
      user.wallet.update(amount: user.wallet.amount.to_f - total_amount.to_f)
    end
  end

  private

  def set_total_amount
    update(total_amount: amount)
  end
end
