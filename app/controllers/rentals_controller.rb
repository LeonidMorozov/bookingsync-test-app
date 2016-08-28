class RentalsController < ApplicationController
  before_action :authenticate_account!
  after_action :allow_bookingsync_iframe

  # GET /rentals.html
  def index
    @rental_types = [
        {id: 'apartment', name: 'Apartment'},
        {id: 'holiday-home', name: 'Holiday Home'},
        {id: 'villa', name: 'Villa'}
    ]
    # TODO: find out how to get pagination details from API response
    page = params[:page].to_i
    page = 1 if page <= 0

    search = search_params
    if search.present?
      @rentals = bookingsync_api.rentals_search(search)
    else
      @rentals = bookingsync_api.rentals(per_page: 10, page: page)
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
      search[:rental_type] = params[:rental_type].join(',') if params[:rental_type].present?
      search
    end

end
