class LoanConfirmationRequest < ApplicationRecord
  enum state: [:pending, :confirmed, :rejected]

  validates :loan, :interest_rate, presence: true

  belongs_to :loan
end
