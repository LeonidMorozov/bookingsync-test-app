module BookingsyncApiAuth
  extend ActiveSupport::Concern
  include Pagination

  included do
    before_action :authenticate_account!
    after_action :allow_bookingsync_iframe
  end

  protected

  def bookingsync_api
    #TODO: handle token expired/revoked/etc
    # I think it can be something in `current_account` to make auth back to live
    # it has no re-auth or refresh token mechanism there, at least I didn't find it
    #TODO: FIXME: @api should be in current_account context of course
    @api ||= BookingSync::API.new(current_account.oauth_access_token, logger: Rails.logger)
  end

  def pagination_params
    { per_page: per_page, page: page }
  end

  def rental_types
    [
      { id: "apartment", name: "Apartment" },
      { id: "holiday-home", name: "Holiday Home" },
      { id: "villa", name: "Villa" }
    ]
  end

  def booking_statuses
    [
      { id: "booked", name: "Booked" },
      { id: "unavailable", name: "Unavailable" },
      { id: "tentative", name: "Tentative" }
    ]
  end

  def rentals
    Rails.cache.fetch(cache_key("rentals"), expires_in: CACHE_TTL) do
      bookingsync_api.rentals(fields: [:id, :name], auto_paginate: true)
        .collect { |p| { name: p[:name], id: p[:id] } }
    end
  end

  def clients
    Rails.cache.fetch(cache_key("clients"), expires_in: CACHE_TTL) do
      bookingsync_api.clients(fields: [:id, :fullname], auto_paginate: true)
        .collect { |p| { fullname: p[:fullname], id: p[:id] } }
    end
  end

  private

  def cache_key(key)
    "account_#{current_account.id}/#{key}"
  end

end
