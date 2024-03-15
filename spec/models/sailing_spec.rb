require 'rails_helper'

describe Sailing do
  let(:sailing) { described_class.new(**sailing_attributes) }
  let(:sailing_attributes) do
    {"origin_port"=>"CNSHA",
     "destination_port"=>"NLRTM",
     "departure_date"=>"2022-02-01",
     "arrival_date"=>"2022-03-01",
     "sailing_code"=>"ABCD",
     "rate"=>rate,
     "rate_currency"=>rate_currency,
     "usd"=>usd,
     "jpy"=>jpy}
  end
  let(:rate) { "589.30" }
  let(:rate_currency) { "USD" }
  let(:usd) { 1.126 }
  let(:jpy) { 130.15 }
  let(:rate_in_euro) { 523.36 }

  context "#to_json" do
    it 'returns valid json' do
      expect(JSON.parse(sailing.to_json)).to be_a(Hash)
    end
  end

  context "#days_for_arrival" do
    it 'returns number of days' do
      expect(sailing.days_for_arrival).to eq(28)
    end
  end

  context '#rate_in_euro' do
    let(:rate) { "589.30" }
    let(:rate_currency) { "USD" }
    let(:usd) { 1.126 }
    let(:jpy) { 130.15 }
    let(:rate_in_euro) { 523.36 }

    it 'returns rate in euro' do
      expect(sailing.rate_in_euro).to eq(rate_in_euro)
    end
  end

  context 'when rate_currency is jpy' do
    let(:rate) { "97453" }
    let(:rate_currency) { "JPY" }
    let(:usd) { 1.1156 }
    let(:jpy) { 131.2 }
    let(:rate_in_euro) { 742.78 }

    it 'returns rate in euro' do
      expect(sailing.rate_in_euro).to eq(rate_in_euro)
    end
  end

  context 'when rate_currency is eur' do
    let(:rate) { "742.78" }
    let(:rate_currency) { 'EUR' }
    let(:usd) { nil }
    let(:jpy) { nil }
    let(:rate_in_euro) { 742.78 }

    it 'returns rate in euro' do
      expect(sailing.rate_in_euro).to eq(rate_in_euro)
    end
  end
end
