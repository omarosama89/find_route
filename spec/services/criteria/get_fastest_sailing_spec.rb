require 'rails_helper'

describe Criteria::GetFastestSailing do
  subject do
    described_class.new(route_information: route_information)
  end

  let(:route_information) { RouteInformation.new(origin_port: origin_port, destination_port: destination_port, sailings: sailings) }
  let(:origin_port) { 'CNSHA' }
  let(:destination_port) { 'NLRTM' }

  context "when direct sailings" do
    let(:fastest_sailing) do
      Sailing.new(
        origin_port: 'CNSHA', destination_port: "NLRTM", rate: "456.78", rate_currency: "USD",
        usd: 1.1138, departure_date: "2022-02-01", arrival_date: "2022-03-01"
      )
    end
    let(:sailings) do
      [
        fastest_sailing,
        Sailing.new(origin_port: 'CNSHA', destination_port: "NLRTM", rate: "456.78", "rate_currency": "EUR", departure_date: "2022-02-01", arrival_date: "2022-03-15"),
        Sailing.new(origin_port: 'CNSHA', destination_port: "NLRTM", rate: "97453", "rate_currency": "JPY", jpy: 149.93, departure_date: "2022-02-01", arrival_date: "2022-03-21"),
        Sailing.new(origin_port: 'ESBCN', destination_port: "NLRTM", rate: "356.78", "rate_currency": "EUR", departure_date: "2022-01-01", arrival_date: "2022-04-01")
      ]
    end

    it 'returns the fastest sailing' do
      expect(subject.call).to be(fastest_sailing)
    end
  end

  context "when indirect sailings" do
      let(:fastest_sailing) do
        [
          Sailing.new(origin_port: 'CNSHA', destination_port: "ESBCN", rate: "100.78", "rate_currency": "USD", usd: 1.1138, departure_date: "2022-02-01", arrival_date: "2022-02-15"),
          Sailing.new(origin_port: 'ESBCN', destination_port: "NLRTM", rate: "90.78", "rate_currency": "EUR", departure_date: "2022-02-20", arrival_date: "2022-03-01")
        ]
      end
      let(:sailings) do
        [
          *fastest_sailing,
          Sailing.new(origin_port: 'CNSHA', destination_port: "NLRTM", rate: "500.78", "rate_currency": "EUR", departure_date: "2022-02-01", arrival_date: "2022-03-15"),
          Sailing.new(origin_port: 'CNSHA', destination_port: "NLRTM", rate: "97453", "rate_currency": "JPY", jpy: 149.93, departure_date: "2022-02-01", arrival_date: "2022-03-15"),
          Sailing.new(origin_port: 'ESBCN', destination_port: "NLRTM", rate: "356.78", "rate_currency": "EUR", departure_date: "2022-02-01", arrival_date: "2022-03-15")
        ]
      end

      it 'returns the fastest sailing' do
        expect(subject.call).to match_array(fastest_sailing)
      end
    end
end
