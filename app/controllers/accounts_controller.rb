class AccountsController < ApplicationController
  before_action :authenticate_account!
  after_action :allow_bookingsync_iframe

  # GET /accounts.html
  def index
    page = params[:page].to_i
    page = 1 if page <= 0
    @accounts = bookingsync_api.accounts(per_page: 10, page: page)
  end

  # GET /accounts/1.html
  def show
    @account = bookingsync_api.account(params[:id])
  end
end
