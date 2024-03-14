require 'rails_helper'

describe Sailing do
  let(:sailing) { described_class.new(**sailing_attributes) }

  context 'when rate_currency is usd' do
    let(:sailing_attributes) do
      {"origin_port"=>"CNSHA",
       "destination_port"=>"NLRTM",
       "departure_date"=>"2022-02-01",
       "arrival_date"=>"2022-03-01",
       "sailing_code"=>"ABCD",
       "rate"=>"589.30",
       "rate_currency"=>"USD",
       "usd"=>1.126,
       "jpy"=>130.15}
    end
    let(:rate_in_euro) { 523.36 }

    it 'returns rate in euro' do
      expect(sailing.rate_in_euro).to eq(rate_in_euro)
    end
  end

  context 'when rate_currency is jpy' do
    let(:sailing_attributes) do
      {"origin_port"=>"CNSHA",
       "destination_port"=>"NLRTM",
       "departure_date"=>"2022-01-31",
       "arrival_date"=>"2022-02-28",
       "sailing_code"=>"IJKL",
       "rate"=>"97453",
       "rate_currency"=>"JPY",
       "usd"=>1.1156,
       "jpy"=>131.2}
    end
    let(:rate_in_euro) { 742.78 }

    it 'returns rate in euro' do
      expect(sailing.rate_in_euro).to eq(rate_in_euro)
    end

    context "#to_json" do
      it 'returns valid json' do
        expect(JSON.parse(sailing.to_json)).to be_a(Hash)
      end
    end
  end
end
