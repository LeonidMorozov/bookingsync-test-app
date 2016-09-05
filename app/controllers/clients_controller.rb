class ClientsController < ApplicationController
  include BookingsyncApiAuth

  # GET /clients.html
  def index
    @clients = bookingsync_api.clients(pagination_params)
  end

  # GET /clients/1.html
  def show
    @client = bookingsync_api.client(params[:id])
  end
end
