class AccountsController < ApplicationController
  include BookingsyncApiControllerBase
  include Pagination

  # GET /accounts.html
  def index
    @accounts = bookingsync_api.accounts(per_page: per_page, page: page)
  end

  # GET /accounts/1.html
  def show
    @account = bookingsync_api.account(params[:id])
  end
end
