module AuthControllerBase
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_account!
    after_action :allow_bookingsync_iframe
  end

end
