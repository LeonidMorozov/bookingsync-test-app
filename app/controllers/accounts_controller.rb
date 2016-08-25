class AccountsController < ApplicationController
  before_action :authenticate_account!
  after_action :allow_bookingsync_iframe

  # GET /accounts.html
  def index
  end

  # GET /accounts/1.html
  def show
  end
end
