require "rails_helper"
require_relative "../../../app/controllers/concerns/bookingsync_api_auth"

# create anonymous fake controller
class Concerns::BookingsyncApiAuth < ApplicationController
  include BookingsyncApiAuth
end

describe Concerns::BookingsyncApiAuth, type: :controller do
  context "pagination_params" do
    it "default values" do
      expect(controller.send(:pagination_params)).to eql(per_page: 10, page: 1)
    end
    it "with params" do
      controller.params[:page] = "5"
      controller.params[:per_page] = "3"
      expect(controller.send(:pagination_params)).to eql(per_page: 3, page: 5)
    end
  end

  context "rental_types" do
    it "values" do
      result = [
        { id: "apartment", name: "Apartment" },
        { id: "holiday-home", name: "Holiday Home" },
        { id: "villa", name: "Villa" }
      ]
      expect(controller.send(:rental_types)).to eql(result)
    end
  end

  context "booking_statuses" do
    it "values" do
      result = [
        { id: "booked", name: "Booked" },
        { id: "unavailable", name: "Unavailable" },
        { id: "tentative", name: "Tentative" }
      ]
      expect(controller.send(:booking_statuses)).to eql(result)
    end
  end

  context "cache_key" do
    let(:current_account){ double("current_account", id: 1) }

    it "proper value" do
      allow(controller).to receive(:current_account).and_return(current_account)
      expect(controller.send(:cache_key, "key")).to eql("account_#{current_account.id}/key")
    end
  end

  context "rentals" do
    let(:api_stubbed){ double("bookingsync_api", rentals: true) }
    let(:rental_id) { 1 }
    let(:rental_name) { "Rental 1" }
    let(:api_results){ [{ id: rental_id, name: rental_name }] }

    it "proper value" do
      Rails.cache.clear
      allow(controller).to receive(:bookingsync_api).and_return(api_stubbed)
      allow(controller).to receive(:cache_key).and_return("abc")
      expect(api_stubbed).to receive(:rentals).with(fields: [:id, :name], auto_paginate: true).and_return(api_results)
      expect(controller.send(:rentals)).to eql(api_results)
    end
  end

  context "clients" do
    let(:api_stubbed){ double("bookingsync_api", clients: true) }
    let(:client_id) { 1 }
    let(:client_name) { "Client 1" }
    let(:api_results){ [{ id: client_id, fullname: client_name }] }

    it "proper value" do
      Rails.cache.clear
      allow(controller).to receive(:bookingsync_api).and_return(api_stubbed)
      allow(controller).to receive(:cache_key).and_return("abc")
      expect(api_stubbed).to receive(:clients).with(fields: [:id, :fullname], auto_paginate: true).and_return(api_results)
      expect(controller.send(:clients)).to eql(api_results)
    end
  end
end
