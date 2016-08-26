class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

    def bookingsync_api
      @api ||= BookingSync::API.new(current_account.oauth_access_token, logger: Rails.logger)
    end

end
