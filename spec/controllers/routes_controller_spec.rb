require 'rails_helper'

describe RoutesController do
  before do
    allow(GetCheapestSailing)
      .to(receive(:new).with(origin_port: origin_port, destination_port: destination_port, sailings: anything))
      .and_return(result)
  end

  describe "GET index" do
    context "when origin and destination ports are valid" do
      let(:origin_port) { 'origin_port' }
      let(:destination_port) { 'destination_port' }
      let(:sailings) { SailingsBuilder.new.call }
      let(:result) { double(call: double(success?: true, value!: double)) }

      it "return value" do
        get :index, params: { origin_port: origin_port, destination_port: destination_port}

        expect(response.code).to eq("200")
      end
    end

    context "when origin or destination ports are invalid" do
      let(:origin_port) { 'origin_port' }
      let(:destination_port) { 'destination_port' }
      let(:sailings) { SailingsBuilder.new.call }
      let(:result) { double(call: double(success?: false, failure: double)) }

      it "return value" do
        get :index, params: { origin_port: origin_port, destination_port: destination_port}

        expect(response.code).to eq("400")
      end
    end
  end
end
