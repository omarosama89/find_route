require 'rails_helper'

describe Criteria::GetCheapestSailing do
  subject do
    described_class.new(origin_port: origin_port, destination_port: destination_port, sailings: sailings)
  end

  let(:origin_port) { 'CNSHA' }
  let(:destination_port) { 'NLRTM' }

  context 'origin_port and destination_port are valid' do
    context "when direct sailings" do
      let(:cheapest_sailing) { Sailing.new(origin_port: 'CNSHA', destination_port: "NLRTM", rate: "456.78", "rate_currency": "USD", usd: 1.1138, departure_date: "2022-02-01", arrival_date: "2022-03-15") }
      let(:sailings) do
        [
          cheapest_sailing,
          Sailing.new(origin_port: 'CNSHA', destination_port: "NLRTM", rate: "456.78", "rate_currency": "EUR", departure_date: "2022-02-01", arrival_date: "2022-03-15"),
          Sailing.new(origin_port: 'CNSHA', destination_port: "NLRTM", rate: "97453", "rate_currency": "JPY", jpy: 149.93, departure_date: "2022-02-01", arrival_date: "2022-03-15"),
          Sailing.new(origin_port: 'ESBCN', destination_port: "NLRTM", rate: "356.78", "rate_currency": "EUR", departure_date: "2022-02-01", arrival_date: "2022-03-15")
        ]
      end

      it 'returns the cheapest sailing' do
        expect(subject.call).to be(cheapest_sailing)
      end
    end

    context "when indirect sailings" do
      let(:cheapest_sailing) do
        [
          Sailing.new(origin_port: 'CNSHA', destination_port: "ESBCN", rate: "100.78", "rate_currency": "USD", usd: 1.1138, departure_date: "2022-02-01", arrival_date: "2022-03-15"),
          Sailing.new(origin_port: 'ESBCN', destination_port: "NLRTM", rate: "90.78", "rate_currency": "EUR", departure_date: "2022-03-20", arrival_date: "2022-03-15")
        ]
      end
      let(:sailings) do
        [
          *cheapest_sailing,
          Sailing.new(origin_port: 'CNSHA', destination_port: "NLRTM", rate: "500.78", "rate_currency": "EUR", departure_date: "2022-02-01", arrival_date: "2022-03-15"),
          Sailing.new(origin_port: 'CNSHA', destination_port: "NLRTM", rate: "97453", "rate_currency": "JPY", jpy: 149.93, departure_date: "2022-02-01", arrival_date: "2022-03-15"),
          Sailing.new(origin_port: 'ESBCN', destination_port: "NLRTM", rate: "356.78", "rate_currency": "EUR", departure_date: "2022-02-01", arrival_date: "2022-03-15")
        ]
      end

      it 'returns the cheapest sailing' do
        expect(subject.call).to match_array(cheapest_sailing)
      end
    end
  end
end
