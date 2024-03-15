require 'rails_helper'

describe RoutesController do
  let(:criteria) { 'cheapest' }
  let(:origin_port) { 'origin_port' }
  let(:destination_port) { 'destination_port' }
  let(:sailings) { SailingsBuilder.new.call }
  let(:params) do
    { origin_port: origin_port, destination_port: destination_port, criteria: criteria }
  end
  let(:failure_double) { instance_double('GetSailings', call: instance_double('Failure', success?: false, failure: error_message)) }
  let(:success_double) { instance_double('GetSailings', call: instance_double('Success', success?: true, value!: sailing_result)) }

  before do
    allow(GetSailings)
      .to(receive(:new).with(origin_port: origin_port, destination_port: destination_port, sailings: anything, criteria: criteria))
      .and_return(result)
  end

  describe "GET index" do
    context "when criteria is invalid" do
      let(:criteria) { 'invalid-criteria' }
      let(:error_message) { 'error-message' }
      let(:result) { failure_double }

      it "returns bad request (400)" do
        get :index, params: params

        expect(response.code).to eq("400")
        expect(JSON.parse(response.body)).to match({ "error" => error_message })
      end
    end

    context "when origin or destination ports are invalid" do
      let(:result) { failure_double }
      let(:error_message) { 'error-message' }

      it "returns bad request (400)" do
        get :index, params: params

        expect(response.code).to eq("400")
        expect(JSON.parse(response.body)).to match({ "error" => error_message })
      end
    end

    context "when criteria is cheapest" do
      let(:criteria) { 'cheapest' }

      context "when direct sailing" do
        let(:origin_port) { 'origin_port' }
        let(:destination_port) { 'destination_port' }
        let(:sailings) { SailingsBuilder.new.call }
        let(:sailing_result) { sailings.last }
        let(:result) { success_double }

        it "returns 200 status code" do
          get :index, params: params

          expect(response.code).to eq("200")
        end

        it "returns sailing result" do
          get :index, params: params

          expect(response.body).to eq(sailing_result.to_json)
        end
      end

      context "when indirect sailing" do
        let(:origin_port) { 'origin_port' }
        let(:destination_port) { 'destination_port' }
        let(:sailings) { SailingsBuilder.new.call }
        let(:sailing_result) { sailings.last(2) }
        let(:result) { success_double }

        it "returns 200 status code" do
          get :index, params: params

          expect(response.code).to eq("200")
        end

        it "returns sailing result" do
          get :index, params: params

          expect(response.body).to eq(sailing_result.to_json)
        end
      end
    end

    context "when criteria is fastest" do
      let(:criteria) { 'fastest' }

      context "when direct sailing" do
        let(:origin_port) { 'origin_port' }
        let(:destination_port) { 'destination_port' }
        let(:sailings) { SailingsBuilder.new.call }
        let(:sailing_result) { sailings.last }
        let(:result) { success_double }

        it "returns 200 status code" do
          get :index, params: params

          expect(response.code).to eq("200")
        end

        it "returns sailing result" do
          get :index, params: params

          expect(response.body).to eq(sailing_result.to_json)
        end
      end

      context "when indirect sailing" do
        let(:origin_port) { 'origin_port' }
        let(:destination_port) { 'destination_port' }
        let(:sailings) { SailingsBuilder.new.call }
        let(:sailing_result) { sailings.last(2) }
        let(:result) { success_double }

        it "returns 200 status code" do
          get :index, params: params

          expect(response.code).to eq("200")
        end

        it "returns sailing result" do
          get :index, params: params

          expect(response.body).to eq(sailing_result.to_json)
        end
      end
    end
  end
end
