class AccountsController < ApplicationController
  before_action :authenticate_account!
  after_action :allow_bookingsync_iframe

  # GET /accounts.html
  def index
    @per_page = params[:per_page].present? ? params[:per_page].to_i : 50
    @accounts = bookingsync_api.accounts(per_page: @per_page, page: params[:page])
  end

  # GET /accounts/1.html
  def show
  end
end
