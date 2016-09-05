class ClientsController < ApplicationController
  include BookingsyncApiControllerBase
  include Pagination

  # GET /clients.html
  def index
    @clients = bookingsync_api.clients(per_page: per_page, page: page)
  end

  # GET /clients/1.html
  def show
    @client = bookingsync_api.client(params[:id])
  end
end
