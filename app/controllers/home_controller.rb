# frozen_string_literal: true

# class to handle user dashboard
class HomeController < ApplicationController

  # GET /
  def dashboard
    @requested_loans = user_loans.requests.page(params[:requested_loans_page])
    @active_loans = user_loans.open.page(params[:active_loans_page])
    @paid_loans = user_loans.closed.page(params[:paid_loans_page])
  end

  private

  def user_loans
    current_user.loans
  end
end
