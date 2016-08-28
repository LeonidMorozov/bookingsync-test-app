class BookingsController < ApplicationController
  before_action :authenticate_account!
  after_action :allow_bookingsync_iframe

  # GET /bookings.html
  def index
    # TODO: ideally should be modal/popup window with search instead of select tag on @rentals and @bookings
    @rentals = bookingsync_api.rentals({fields: [:id,:name]})
    @clients = bookingsync_api.clients({fields: [:id,:fullname]})
    @booking_statuses = [
        {id: 'booked', name: 'Booked'},
        {id: 'unavailable', name: 'Unavailable'},
        {id: 'tentative', name: 'Tentative'}
    ]
    # TODO: find out how to get pagination details from API response
    page = params[:page].to_i
    page = 1 if page <= 0

    search = search_params
    if search.present?
      @bookings = bookingsync_api.bookings(search)
    else
      @bookings = bookingsync_api.bookings(per_page: 10, page: page)
    end

  end

  # GET /bookings/1.html
  def show
    @booking = bookingsync_api.booking(params[:id])
  end

  private

    def search_params
      search = {}
      search[:rental_id] = params[:rental_id].to_i if params[:rental_id].present?
      search[:client_id] = params[:client_id].to_i if params[:client_id].present?
      search[:booking_status] = params[:booking_status].strip.to_a if params[:booking_status].present?
      search[:include_canceled] = ['true', true].include?(params[:include_canceled]) if params[:include_canceled].present?
      search
    end

end
