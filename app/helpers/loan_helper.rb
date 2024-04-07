module LoanHelper
  def accept_reject_confirmation_button(loan)
    content = ''
    if loan.loan_confirmation_request.present? && loan.loan_confirmation_request.pending?
      if loan.loan_confirmation_request.interest_rate != 5
        content += "Updated interest rate by Admin - #{loan.loan_confirmation_request.interest_rate} %"
      end
      buttons_content = safe_join([
        button_to('Accept', accept_confirmation_request_loan_path(loan), method: :put, class: 'accept-button'),
        button_to('Reject', reject_confirmation_request_loan_path(loan), method: :put, class: 'reject-button')
      ])
      content += "<div class='confirmation-buttons'>#{buttons_content}</div>".html_safe
    else
      content += loan.loan_confirmation_request.present? ? loan.loan_confirmation_request.state.capitalize : '--'
    end

    content.html_safe
  end
end
