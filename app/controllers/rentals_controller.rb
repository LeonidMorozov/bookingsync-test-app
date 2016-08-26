class RentalsController < ApplicationController
  before_action :authenticate_account!
  after_action :allow_bookingsync_iframe

  # GET /rentals.html
  def index
    page = params[:page].to_i
    page = 1 if page <= 0
    @rentals = bookingsync_api.rentals(per_page: 10, page: page)
  end

  # GET /rentals/1.html
  def show
    @rental = bookingsync_api.rental(params[:id])
  end
end
