require "rails_helper"
require_relative "../../../app/controllers/concerns/pagination"

# create anonymous fake controller
class Concerns::Pagination < ApplicationController
  include Pagination
end

describe Concerns::Pagination, type: :controller do
  context "with a params[:page]" do
    context "valid value" do
      it "pass page param" do
        controller.params[:page] = "5"
        expect(controller.send(:page)).to eql(5)
      end
    end

    context "invalid value" do
      let(:default_value) { 1 }

      it "non-int value" do
        controller.params[:page] = "abc"
        expect(controller.send(:page)).to eql(default_value)
      end
      it "value too low" do
        controller.params[:page] = "-1"
        expect(controller.send(:page)).to eql(default_value)
      end
      it "no value" do
        expect(controller.send(:page)).to eql(default_value)
      end
    end
  end

  context "with a params[:per_page]" do
    context "valid value" do
      it "pass per_page param" do
        controller.params[:per_page] = "5"
        expect(controller.send(:per_page)).to eql(5)
      end
    end

    context "invalid value" do
      let(:default_value) { 10 }

      it "non-int value" do
        controller.params[:per_page] = "abc"
        expect(controller.send(:per_page)).to eql(default_value)
      end
      it "value too low" do
        controller.params[:per_page] = "-1"
        expect(controller.send(:per_page)).to eql(default_value)
      end
      it "value too high" do
        controller.params[:per_page] = "1000"
        expect(controller.send(:per_page)).to eql(default_value)
      end
      it "no value" do
        expect(controller.send(:per_page)).to eql(default_value)
      end
    end
  end
end
