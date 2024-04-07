# frozen_string_literal: true

class AutoRepayLoanJob
  include Sidekiq::Worker

  ADMIN = AdminUser.last

  def perform
    puts '============= Auto Repay Loan Job starts ============'

    users = User.all
    users.each do |user|
      active_loans = user.loans.open
      loan_amounts = active_loans.map(&:total_amount).inject(:+).to_f
      wallet_balance = user.wallet.amount.to_f
      next if loan_amounts <= wallet_balance

      # if total amount of loans of the user execeeds user's wallet balance
      # auto-debit loan amount and cancel all loans.
      active_loans.update_all(
        state: 'closed', end_date: DateTime.now.utc,
        notes: "Total active loan amount of user was Rs.#{loan_amounts}.\n Maximum amount debited from wallet can be Rs.#{wallet_balance}.\n Current active loans of user automatically cancelled."
      )
      ADMIN.wallet.update(amount: ADMIN.wallet.amount.to_f + wallet_balance)
      user.wallet.update(amount: 0)
    end

    puts '============= Auto Repay Loan Job ends ============'
  end
end
