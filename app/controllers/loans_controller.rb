# frozen_string_literal: true

# class to handle loan & loan confirmation related functionality
class LoansController < ApplicationController
  before_action :fetch_loan, only: %i[accept_confirmation_request reject_confirmation_request repay]

  ADMIN = AdminUser.last

  # GET /loans/new
  def new
    @loan = Loan.new
  end

  # POST /loans
  def create
    @loan = Loan.new(loan_params.merge(user_id: current_user.id))
    if @loan.save
      redirect_to root_path, notice: 'Loan request sent successfully'
    else
      flash[:alert] = @loan.errors.full_messages.join(', ')
      redirect_to new_loan_path
    end
  end

  # PUT /loans/:id/accept_confirmation_request
  def accept_confirmation_request
    if @loan.start_loan!
      redirect_to root_path, notice: 'Loan confiration request (with updated interest rate) accepted'
    else
      redirect_to root_path, notice: 'Could not accept confiration request'
    end
  end

  # PUT /loans/:id/reject_confirmation_request
  def reject_confirmation_request
    if @loan.reject_loan!
      redirect_to root_path, notice: 'Loan confiration request rejected'
    else
      redirect_to root_path, notice: 'Could not reject loan confirmation request'
    end
  end

  # PUT /loans/:id/repay
  def repay
    if @loan.repay_loan!
      redirect_to root_path, notice: 'Loan paid successfully'
    else
      redirect_to root_path, notice: "Couldn't pay loan"
    end
  end

  private

  def fetch_loan
    @loan = Loan.find_by(id: params[:id])
  end

  def loan_params
    params.require(:loan).permit(:amount)
  end
end
