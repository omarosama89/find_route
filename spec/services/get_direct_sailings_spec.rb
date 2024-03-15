require 'rails_helper'

describe GetDirectSailings do
  subject do
    described_class.new(origin_port: origin_port, destination_port: destination_port, sailings: sailings)
  end

  let(:direct_sailings) do
      Sailing.new(origin_port: 'CNSHA', destination_port: "NLRTM", rate: "456.78", "rate_currency": "USD", usd: 1.1138)
  end
  let(:sailings) do
    [
      *direct_sailings,
      Sailing.new(origin_port: 'QWERT', destination_port: "NLRTM", rate: "97453", "rate_currency": "JPY", jpy: 149.93),
      Sailing.new(origin_port: 'ESBCN', destination_port: "NLRTM", rate: "356.78", "rate_currency": "EUR")
    ]
  end

  context 'when there is only one sailing' do
    let(:origin_port) { 'CNSHA' }
    let(:destination_port) { 'NLRTM' }

    it 'returns the cheapest sailing' do
      expect(subject.call).to match_array(direct_sailings)
    end
  end

  context 'when there are more than one sailing' do
    let(:origin_port) { 'CNSHA' }
    let(:destination_port) { 'NLRTM' }

    let(:direct_sailings) do
      [
        Sailing.new(origin_port: 'CNSHA', destination_port: "NLRTM", rate: "97453", "rate_currency": "JPY", jpy: 149.93),
        Sailing.new(origin_port: 'CNSHA', destination_port: "NLRTM", rate: "456.78", "rate_currency": "USD", usd: 1.1138)
      ]
    end

    it 'returns the cheapest sailing' do
      expect(subject.call).to match_array(direct_sailings)
    end
  end
end
