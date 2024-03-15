require 'rails_helper'

describe GetSailings do
  subject do
    described_class.new(origin_port: origin_port, destination_port: destination_port, sailings: sailings, criteria: criteria)
  end

  let(:criteria) { 'cheapest' }
  let(:cheapest_sailing) do
      Sailing.new(origin_port: 'CNSHA', destination_port: "NLRTM", rate: "70.78", "rate_currency": "USD", usd: 1.1138, departure_date: "2022-02-01", arrival_date: "2022-03-15")
  end
  let(:direct_sailings) do
    [
      cheapest_sailing,
      Sailing.new(origin_port: 'CNSHA', destination_port: "ESBCN", rate: "708.78", "rate_currency": "USD", usd: 1.1138, departure_date: "2022-02-01", arrival_date: "2022-02-28"),
      Sailing.new(origin_port: 'ESBCN', destination_port: "NLRTM", rate: "403.78", "rate_currency": "USD", usd: 1.1138, departure_date: "2022-03-01", arrival_date: "2022-03-15")
    ]
  end
  let(:indirect_connected_sailings) do
    [
      Sailing.new(origin_port: 'CNSHA', destination_port: "ESBCN", rate: "30.78", "rate_currency": "USD", usd: 1.1138, departure_date: "2022-02-01", arrival_date: "2022-02-28"),
      Sailing.new(origin_port: 'ESBCN', destination_port: "NLRTM", rate: "20.78", "rate_currency": "USD", usd: 1.1138, departure_date: "2022-03-01", arrival_date: "2022-03-15")
    ]
  end
  let(:indirect_disconnected_sailings) do
    [
      Sailing.new(origin_port: 'CNSHA', destination_port: "ESBCN", rate: "708.78", "rate_currency": "USD", usd: 1.1138, departure_date: "2022-02-01", arrival_date: "2022-02-28"),
      Sailing.new(origin_port: 'ESBCN', destination_port: "NLRTM", rate: "403.78", "rate_currency": "USD", usd: 1.1138, departure_date: "2022-02-01", arrival_date: "2022-03-15")
    ]
  end
  let(:indirect_sailings) do
    [
      indirect_connected_sailings,
      indirect_connected_sailings
    ]
  end
  let(:fastest_sailing) do
    Sailing.new(origin_port: 'CNSHA', destination_port: "ESBCN", rate: "708.78", "rate_currency": "USD", usd: 1.1138, departure_date: "2022-02-01", arrival_date: "2022-02-05")
  end
  let(:sailings) do
    [
      *direct_sailings,
      *indirect_connected_sailings,
      *indirect_disconnected_sailings,
      fastest_sailing
    ]
  end
  let(:cheapest_sailing_result) { cheapest_sailing }
  let(:fastest_sailing_result) { fastest_sailing }
  let(:origin_port) { 'CNSHA' }
  let(:destination_port) { 'NLRTM' }

  before do
    allow(Criteria::GetCheapestSailing)
      .to(receive(:new).with(origin_port: origin_port, destination_port: destination_port, sailings: sailings))
      .and_return(instance_double('Criteria::GetCheapestSailing', call: cheapest_sailing_result))
    allow(Criteria::GetFastestSailing)
      .to(receive(:new).with(origin_port: origin_port, destination_port: destination_port, sailings: sailings))
      .and_return(instance_double('Criteria::GetFastestSailing', call: fastest_sailing_result))
  end

  context 'origin_port or destination_port is invalid' do
    let(:origin_port) { 'CNSHA' }
    let(:destination_port) { 'QWERT' }
    let(:error) { 'Invalid origin/destination port!' }

    it 'returns an error' do
      expect(subject.call.failure).to eq(error)
    end
  end

  context 'when criterion is invalid' do
    let(:criteria) { 'no-criteria' }
    let(:origin_port) { 'CNSHA' }
    let(:destination_port) { 'NLRTM' }
    let(:error_message) { 'Invalid criteria!' }

    it 'returns an error' do
      expect(subject.call.failure).to eq(error_message)
    end
  end

  context 'When criteria is cheapest' do
    let(:criteria) { 'cheapest' }

    context 'when direct sailings only' do
      context 'origin_port and destination_port are valid' do
        context "when direct sailings" do
          let(:cheapest_sailing_result) { cheapest_sailing }


          it 'returns the cheapest sailing' do
            expect(subject.call.value!).to eq(cheapest_sailing)
          end
        end

        context "when indirect sailings" do
          let(:cheapest_sailing_result) { indirect_connected_sailings }

          it 'returns the cheapest sailing' do
            expect(subject.call.value!).to eq(indirect_connected_sailings)
          end
        end
      end
    end
  end

  context 'When criteria is fastest' do
    let(:criteria) { 'fastest' }

    context 'when direct sailings only' do
      context 'origin_port and destination_port are valid' do
        context "when direct sailings" do
          let(:fastest_sailing_result) { fastest_sailing }
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
            expect(subject.call.value!).to eq(fastest_sailing)
          end
        end

        context "when indirect sailings" do
          let(:fastest_sailing) do
            [
              Sailing.new(origin_port: 'CNSHA', destination_port: "ESBCN", rate: "100.78", "rate_currency": "USD", usd: 1.1138, departure_date: "2022-02-01", arrival_date: "2022-02-15"),
              Sailing.new(origin_port: 'ESBCN', destination_port: "NLRTM", rate: "90.78", "rate_currency": "EUR", departure_date: "2022-02-01", arrival_date: "2022-03-01")
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
          let(:fastest_sailing_result) { fastest_sailing }

          it 'returns the fastest sailing' do
            expect(subject.call.value!).to eq(fastest_sailing)
          end
        end
      end
    end
  end
end
