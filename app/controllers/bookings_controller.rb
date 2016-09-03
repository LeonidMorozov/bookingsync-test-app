class BookingsController < ApplicationController
  before_action :authenticate_account!
  after_action :allow_bookingsync_iframe

  # GET /bookings.html
  def index
    # TODO: ideally should be modal/popup window with search instead of select tag on @rentals and @bookings
    # TODO: find out how to get pagination details from API response
    page = params[:page].to_i
    page = 1 if page <= 0

    @rentals = rentals
    @clients = clients
    @booking_statuses = booking_statuses
    search = search_params
    if search.present?
      #TODO: expected bookingsync_api.bookings_search there
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

  def rentals
    Rails.cache.fetch("account_#{current_account.id}/rentals", expires_in: CACHE_TTL) do
      bookingsync_api.rentals(fields: [:id, :name], auto_paginate: true)
          .collect { |p| { name: p[:name], id: p[:id] } }
    end
  end

  def clients
    Rails.cache.fetch("account_#{current_account.id}/clients", expires_in: CACHE_TTL) do
      bookingsync_api.clients(fields: [:id, :fullname], auto_paginate: true)
          .collect { |p| { fullname: p[:fullname], id: p[:id] } }
    end
  end

  def booking_statuses
    [
        { id: "booked", name: "Booked" },
        { id: "unavailable", name: "Unavailable" },
        { id: "tentative", name: "Tentative" }
    ]
  end

  def search_params
    search = {}
    search[:rental_id] = params[:rental_id].to_i if params[:rental_id].present?
    search[:client_id] = params[:client_id].to_i if params[:client_id].present?
    search[:status] = params[:booking_status].strip if params[:booking_status].present?
    search[:include_canceled] = ["true", true].include?(params[:include_canceled]) if params[:include_canceled].present?
    search
  end
end
