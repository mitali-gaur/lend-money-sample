# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_req!
  before_action :fetch_user_wallet

  private

  def authenticate_req!
    if request.path.include?('admin')
      authenticate_admin_user!
    else
      authenticate_user!
    end
  end

  def fetch_user_wallet
    if request.path.include?('admin') && current_admin_user
      @wallet = current_admin_user.wallet
    elsif current_user
      @wallet = current_user.wallet
    end
  end
end
