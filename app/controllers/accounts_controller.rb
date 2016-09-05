class AccountsController < ApplicationController
  include BookingsyncApiAuth

  # GET /accounts.html
  def index
    @accounts = bookingsync_api.accounts(pagination_params)
  end

  # GET /accounts/1.html
  def show
    @account = bookingsync_api.account(params[:id])
  end
end
