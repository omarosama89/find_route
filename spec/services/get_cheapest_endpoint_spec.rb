require 'rails_helper'

describe GetCheapestEndpoint do
  subject do
    described_class.new(origin_port: origin_port, destination_port: destination_port, sailings: sailings)
  end

  let(:cheapest_sailing) { Sailing.new(origin_port: 'CNSHA', destination_port: "NLRTM", rate: "456.78", "rate_currency": "USD", usd: 1.1138) }
  let(:sailings) do
    [
      cheapest_sailing,
      Sailing.new(origin_port: 'CNSHA', destination_port: "NLRTM", rate: "456.78", "rate_currency": "EUR"),
      Sailing.new(origin_port: 'CNSHA', destination_port: "NLRTM", rate: "97453", "rate_currency": "JPY", jpy: 149.93),
      Sailing.new(origin_port: 'ESBCN', destination_port: "NLRTM", rate: "356.78", "rate_currency": "EUR")
    ]
  end

  context 'origin_port and destination_port are valid' do
    let(:origin_port) { 'CNSHA' }
    let(:destination_port) { 'NLRTM' }

    it 'returns the cheapest sailing' do
      expect(subject.call.value!).to be(cheapest_sailing)
    end
  end

  context 'origin_port or destination_port is invalid' do
    let(:origin_port) { 'CNSHA' }
    let(:destination_port) { 'QWERT' }
    let(:error) { 'Invalid origin/destination port' }

    it 'returns an error' do
      expect(subject.call.failure).to eq(error)
    end
  end
end
