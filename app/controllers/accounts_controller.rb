class AccountsController < ApplicationController
  before_action :authenticate_account!
  after_action :allow_bookingsync_iframe

  # GET /accounts
  # GET /accounts.json
  def index
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end
end
