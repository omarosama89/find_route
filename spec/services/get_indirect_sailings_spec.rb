require 'rails_helper'

describe GetIndirectSailings do
  subject do
    described_class.new(origin_port: origin_port, destination_port: destination_port, sailings: sailings)
  end

  let(:indirect_sailings) do
    [
      Sailing.new(origin_port: 'CNSHA', destination_port: "ESBCN", rate: "456.78", "rate_currency": "USD", usd: 1.1138),
      Sailing.new(origin_port: 'CNSHA', destination_port: "NLRTM", rate: "456.78", "rate_currency": "EUR")
    ]
  end
  let(:sailings) { SailingsBuilder.new.call }

  context 'origin_port and destination_port are valid' do
    let(:origin_port) { 'CNSHA' }
    let(:destination_port) { 'NLRTM' }

    it 'returns the cheapest sailing' do
      expect(subject.call.count).to eq(2)
    end
  end
end
