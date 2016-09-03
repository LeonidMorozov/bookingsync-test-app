class ClientsController < ApplicationController
  before_action :authenticate_account!
  after_action :allow_bookingsync_iframe

  # GET /clients.html
  def index
    # TODO: find out how to get pagination details from API response
    page = params[:page].to_i
    page = 1 if page <= 0

    @clients = bookingsync_api.clients(per_page: 10, page: page)
  end

  # GET /clients/1.html
  def show
    @client = bookingsync_api.client(params[:id])
  end
end
