class BookingsController < ApplicationController
  include BookingsyncApiAuth

  # GET /bookings.html
  def index
    # TODO: ideally should be modal/popup window with search instead of select tag on @rentals and @bookings
    # TODO: find out how to get pagination details from API response

    @rentals = rentals
    @clients = clients
    @booking_statuses = booking_statuses

    search = search_params

    if search.present?
      #TODO: expected bookingsync_api.bookings_search there
      # assume we have bookingsync_api.bookings_search here, otherwise wo don't need `if search.present?/else` block here
      @bookings = bookingsync_api.bookings(search.merge(pagination_params))
    else
      @bookings = bookingsync_api.bookings(pagination_params)
    end
  end

  # GET /bookings/1.html
  def show
    @booking = bookingsync_api.booking(params[:id])
  end

  private

  def search_params
    search = {}
    search[:rental_id] = params[:rental_id].to_i if params[:rental_id].present? && params[:rental_id].to_i > 0
    search[:client_id] = params[:client_id].to_i if params[:client_id].present? && params[:client_id].to_i > 0
    search[:status] = params[:status].strip if params[:status].present?
    if params[:include_canceled].present? && ["true", true].include?(params[:include_canceled])
      search[:include_canceled] = true
    end
    search
  end
end
