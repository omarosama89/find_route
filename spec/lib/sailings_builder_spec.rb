require 'rails_helper'

describe SailingsBuilder do
  subject { described_class.new }

  let(:sailings) do
    [
      {
        "origin_port" => "CNSHA",
        "destination_port" => "NLRTM",
        "departure_date" => "2022-02-01",
        "arrival_date" => "2022-03-01",
        "sailing_code" => "ABCD"
      },
      {
        "origin_port" => "CNSHA",
        "destination_port" => "NLRTM",
        "departure_date" => "2022-02-02",
        "arrival_date" => "2022-03-02",
        "sailing_code" => "EFGH"
      },
      {
        "origin_port" => "CNSHA",
        "destination_port" => "NLRTM",
        "departure_date" => "2022-01-31",
        "arrival_date" => "2022-02-28",
        "sailing_code" => "IJKL"
      },
      {
        "origin_port" => "CNSHA",
        "destination_port" => "NLRTM",
        "departure_date" => "2022-01-30",
        "arrival_date" => "2022-03-05",
        "sailing_code" => "MNOP"
      },
      {
        "origin_port" => "CNSHA",
        "destination_port" => "NLRTM",
        "departure_date" => "2022-01-29",
        "arrival_date" => "2022-02-15",
        "sailing_code" => "QRST"
      },
      {
        "origin_port" => "CNSHA",
        "destination_port" => "ESBCN",
        "departure_date" => "2022-01-29",
        "arrival_date" => "2022-02-12",
        "sailing_code" => "ERXQ"
      },
      {
        "origin_port" => "ESBCN",
        "destination_port" => "NLRTM",
        "departure_date" => "2022-02-15",
        "arrival_date" => "2022-03-29",
        "sailing_code" => "ETRF"
      },
      {
        "origin_port" => "ESBCN",
        "destination_port" => "NLRTM",
        "departure_date" => "2022-02-16",
        "arrival_date" => "2022-02-20",
        "sailing_code" => "ETRG"
      },
      {
        "origin_port" => "ESBCN",
        "destination_port" => "BRSSZ",
        "departure_date" => "2022-02-16",
        "arrival_date" => "2022-03-14",
        "sailing_code" => "ETRB"
      }
    ]
  end
  let(:rates) do
    [
      {
        "sailing_code" => "ABCD",
        "rate" => "589.30",
        "rate_currency" => "USD"
      },
      {
        "sailing_code" => "EFGH",
        "rate" => "890.32",
        "rate_currency" => "EUR"
      },
      {
        "sailing_code" => "IJKL",
        "rate" => "97453",
        "rate_currency" => "JPY"
      },
      {
        "sailing_code" => "MNOP",
        "rate" => "456.78",
        "rate_currency" => "USD"
      },
      {
        "sailing_code" => "QRST",
        "rate" => "761.96",
        "rate_currency" => "EUR"
      },
      {
        "sailing_code" => "ERXQ",
        "rate" => "261.96",
        "rate_currency" => "EUR"
      },
      {
        "sailing_code" => "ETRF",
        "rate" => "70.96",
        "rate_currency" => "USD"
      },
      {
        "sailing_code" => "ETRG",
        "rate" => "69.96",
        "rate_currency" => "USD"
      },
      {
        "sailing_code" => "ETRB",
        "rate" => "439.96",
        "rate_currency" => "USD"
      }
    ]
  end
  let(:exchange_rates) do
    {
      "2022-01-29" => {
        "usd" => 1.1138,
        "jpy" => 130.85
      },
      "2022-01-30" => {
        "usd" => 1.1138,
        "jpy" => 132.97
      },
      "2022-01-31" => {
        "usd" => 1.1156,
        "jpy" => 131.2
      },
      "2022-02-01" => {
        "usd" => 1.126,
        "jpy" => 130.15
      },
      "2022-02-02" => {
        "usd" => 1.1323,
        "jpy" => 133.91
      },
      "2022-02-15" => {
        "usd" => 1.1483,
        "jpy" => 149.93
      },
      "2022-02-16" => {
        "usd" => 1.1482,
        "jpy" => 149.93
      }
    }
  end

  it 'returns valid sailings data' do
    expect(subject.sailings).to match_array(sailings)
  end

  it 'returns valid rates data' do
    expect(subject.rates).to match_array(rates)
  end

  it 'returns valid exchange rates data' do
    expect(subject.exchange_rates).to match(exchange_rates)
  end
end
