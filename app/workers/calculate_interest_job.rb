# frozen_string_literal: true

class CalculateInterestJob
  include Sidekiq::Worker

  def perform
    puts '============= Calculate interest Job starts ============'

    active_loans = Loan.open
    active_loans.each do |loan|
      last_updated_time = loan.updated_interest_datetime ? loan.updated_interest_datetime : loan.start_date
      time_period = ((DateTime.now.utc - last_updated_time) / 1.minutes)
      next if time_period < 5 # re-calculate interest after every 5 min when loan starts

      time_period_in_years = time_period / (60 * 24 * 365)
      interest_amount = calculate_interest(loan, time_period_in_years)
      loan.update(
        total_amount: loan.amount + interest_amount,
        updated_interest_datetime: DateTime.now.utc
      )
    end

    puts '============= Calculate interest Job ends ============'
  end

  private

  def calculate_interest(loan, time)
    loan.amount * (loan.interest_rate_in_percentage / 100.0) * time
  end
end
