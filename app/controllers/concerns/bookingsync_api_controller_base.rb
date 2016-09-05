module BookingsyncApiControllerBase
  extend ActiveSupport::Concern

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
end
