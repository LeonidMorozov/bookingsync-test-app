require "rails_helper"
require "shared/search_params_examples"

describe BookingsController, type: :controller do
  context "search_params" do
    context "has rental_id" do
      let(:param_name) { :rental_id }
      it_should_behave_like "positive int param examples"
    end
    context "has client_id" do
      let(:param_name) { :client_id }
      it_should_behave_like "positive int param examples"
    end
    context "has status" do
      let(:param_name) { :status }
      it_should_behave_like "non-blank string param examples"
    end
    context "has include_canceled" do
      let(:param_name) { :include_canceled }
      it_should_behave_like "boolean param examples"
    end
  end

  describe "routes" do
    it "routes to /bookings" do
      expect(get: "/bookings").to be_routable
      expect(get: "/bookings/1").to be_routable
      expect(post: "/bookings").not_to be_routable
      expect(put: "/bookings/1").not_to be_routable
      expect(delete: "/bookings/1").not_to be_routable
    end
  end

  describe "actions" do
    let(:booking_id){ 5 }
    let(:booking){ { id: booking_id, start_at: "2016-09-15 00:00:00", end_at: "2016-09-17 00:00:00", status: "Booked" } }

    before do
      allow(controller).to receive(:authenticate_account!).and_return(true)
      allow(controller).to receive(:allow_bookingsync_iframe).and_return(true)
    end

    context "GET index" do
      let(:rentals){ [{ id: 2, name: "Rental 2" }] }
      let(:clients){ [{ id: 3, fullname: "Client 3" }] }
      let!(:bookings){ [booking] }
      let(:params) { {} }
      let(:action) { -> { get :index, params } }
      let(:api_stubbed){ double("bookingsync_api", bookings: true) }

      it "proper value" do
        allow(controller).to receive(:search_params).and_call_original
        allow(controller).to receive(:rentals).and_return(rentals)
        allow(controller).to receive(:clients).and_return(clients)
        allow(controller).to receive(:booking_statuses).and_call_original
        allow(controller).to receive(:bookingsync_api).and_return(api_stubbed)
        expect(api_stubbed).to receive(:bookings).and_return(bookings)
        action.call
        expect(assigns(:bookings)).to eq([booking])
        expect(response).to render_template("index")
      end
    end

    context "GET show" do
      let(:action) { -> { get :show, id: booking_id } }
      let(:api_stubbed){ double("bookingsync_api", booking: true) }

      it "proper value" do
        booking
        allow(controller).to receive(:bookingsync_api).and_return(api_stubbed)
        expect(api_stubbed).to receive(:booking).and_return(booking)
        action.call
        expect(response).to render_template("show")
      end
    end
  end
end
