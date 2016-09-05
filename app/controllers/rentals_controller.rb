class RentalsController < ApplicationController
  include BookingsyncApiControllerBase
  include Pagination

  # GET /rentals.html
  def index
    @rental_types = rental_types
    # TODO: find out how to get pagination details from API response
    search = search_params
    if search.present?
      @rentals = bookingsync_api.rentals_search(search)
    else
      @rentals = bookingsync_api.rentals(per_page: per_page, page: page)
    end
  end

  # GET /rentals/1.html
  def show
    @rental = bookingsync_api.rental(params[:id])
  end

  private

  def rental_types
    [
      { id: "apartment", name: "Apartment" },
      { id: "holiday-home", name: "Holiday Home" },
      { id: "villa", name: "Villa" }
    ]
  end

  def search_params
    search = {}
    search[:city] = params[:city].strip if params[:city].to_s.strip.present?
    search[:rental_type] = params[:rental_type].strip if params[:rental_type].present?
    search
  end
end
