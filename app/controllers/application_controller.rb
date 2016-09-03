class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def bookingsync_api
    #TODO: handle token expired/revoked/etc
    # I think it can be something in `current_account` to make auth back to live
    # it has no re-auth or refresh token mechanism there, at least I didn't find it
    #TODO: FIXME: @api should be in current_account context of course
    @api ||= BookingSync::API.new(current_account.oauth_access_token, logger: Rails.logger)
  end
end
