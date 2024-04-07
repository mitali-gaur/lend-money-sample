ActiveAdmin.register Loan do
  menu priority: 2

  action_item :wallet_amount do
    link_to "Wallet Amount: Rs. #{AdminUser.last.wallet.amount}", "#"
  end

  index download_links: false do
      panel "" do
        # empty template
        table_for Loan.requests do
        end
      end

      panel "Loan Requests" do
        table_for Loan.requests do
          column :user do |loan|
            loan.user.email
          end
          column :state
          column :amount
          column 'Interest rate', :interest_rate_in_percentage
          column :updated_interest_rate do |loan|
            loan.approved? ? loan.loan_confirmation_request.interest_rate : '-'
          end
          column :created_at
          column :updated_at

          actions defaults: false do |loan|
            if loan.requested?
              links = ''.html_safe
              links += link_to('Approve', edit_admin_loan_path(loan))
              links += ' '
              links += link_to('Reject', reject_admin_loan_path(loan), method: :put)
              links
            end
          end
        end
      end

      panel "Active Loans" do
        table_for Loan.open do
          column :user do |loan|
            loan.user.email
          end
          column :start_date
          column 'Principal Amount', :amount
          column 'Interest rate', :interest_rate_in_percentage
          column :total_amount
          column :created_at
          column :updated_at
        end
      end

      panel "Paid Loans" do
        table_for Loan.closed do
          column :user do |loan|
            loan.user.email
          end
          column :start_date
          column :end_date
          column 'Principal Amount', :amount
          column 'Interest rate', :interest_rate_in_percentage
          column :total_amount
          column :created_at
          column :updated_at
        end
      end
  end

  filter :user, as: :select, collection: -> { User.pluck(:email, :id) }

  form do |f|
    f.inputs do
      f.input :user, as: :string, input_html: { readonly: true, value: f.object.user.email }
      f.input :amount, input_html: { readonly: true }
      f.input :state, label: 'Next state', as: :string, input_html: { value: 'Approved', readonly: true }
      f.input :interest_rate_in_percentage, label: 'Updated interest rate (%)'
    end

    f.actions
  end

  permit_params :amount, :state, :interest_rate_in_percentage, :user_id

  actions :index, :show, :edit, :update

  member_action :reject, method: :put do
    loan = Loan.find_by(id: params[:id])
    if loan.update(state: 'rejected')
      flash[:success] = "Loan has been rejected successfully."
    else
      flash[:error] = "Failed to reject loan."
    end

    redirect_to admin_loan_path(loan)
  end

  controller do
    before_action :load_loan, only: [:edit, :update]

    def edit
      unless @loan.requested?
        flash[:error] = "Loan can only be modified in 'Requested' state"
        redirect_to admin_loans_path
      end
    end

    def update
      if @loan.approved!
        @loan.create_loan_confirmation_request(interest_rate: interest_param)
        flash[:success] = "Loan interest updated successfully."
      else
        flash[:error] = "Failed to update loan interest."
      end

      redirect_to admin_loan_path(@loan)
    end

    private

    def load_loan
      @loan = Loan.find_by(id: params[:id])
    end

    def interest_param
      params[:loan][:interest_rate_in_percentage]
    end
  end
end
