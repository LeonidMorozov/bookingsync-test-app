class RentalsController < ApplicationController
  include BookingsyncApiAuth

  # GET /rentals.html
  def index
    @rental_types = rental_types
    # TODO: find out how to get pagination details from API response
    search = search_params
    if search.present?
      @rentals = bookingsync_api.rentals_search(search.merge(pagination_params))
    else
      @rentals = bookingsync_api.rentals(pagination_params)
    end
  end

  # GET /rentals/1.html
  def show
    @rental = bookingsync_api.rental(params[:id])
  end

  private

  def search_params
    search = {}
    search[:city] = params[:city].strip if params[:city].to_s.strip.present?
    search[:rental_type] = params[:rental_type].strip if params[:rental_type].present?
    search
  end
end
