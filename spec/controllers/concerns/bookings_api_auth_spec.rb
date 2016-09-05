require "rails_helper"
require_relative "../../../app/controllers/concerns/bookingsync_api_auth"

# create anonymous fake controller
class Concerns::BookingsyncApiAuth < ApplicationController
  include BookingsyncApiAuth
end

describe Concerns::BookingsyncApiAuth, type: :controller do
  context "pagination_params" do
    it "default values" do
      expect(controller.send(:pagination_params)).to eq(per_page: 10, page: 1)
    end
    it "with params" do
      controller.params[:page] = "5"
      controller.params[:per_page] = "3"
      expect(controller.send(:pagination_params)).to eq(per_page: 3, page: 5)
    end
  end

  context "rental_types" do
    it "values" do
      result = [
        { id: "apartment", name: "Apartment" },
        { id: "holiday-home", name: "Holiday Home" },
        { id: "villa", name: "Villa" }
      ]
      expect(controller.send(:rental_types)).to eq(result)
    end
  end

  context "booking_statuses" do
    it "values" do
      result = [
        { id: "booked", name: "Booked" },
        { id: "unavailable", name: "Unavailable" },
        { id: "tentative", name: "Tentative" }
      ]
      expect(controller.send(:booking_statuses)).to eq(result)
    end
  end

  context "cache_key" do
    let(:current_account){ double("current_account", id: 1) }

    it "proper value" do
      allow(controller).to receive(:current_account).and_return(current_account)
      expect(controller.send(:cache_key, "key")).to eq("account_#{current_account.id}/key")
    end
  end
end
