require 'rails_helper'

describe RouteInformation do
  subject do
    described_class.new(origin_port: origin_port, destination_port: destination_port, sailings: sailings)
  end

  let(:sailings) do
    [
      Sailing.new(origin_port: 'CNSHA', destination_port: "ESBCN", rate: "30.78", "rate_currency": "USD", usd: 1.1138, departure_date: "2022-02-01", arrival_date: "2022-02-28"),
      Sailing.new(origin_port: 'ESBCN', destination_port: "NLRTM", rate: "20.78", "rate_currency": "USD", usd: 1.1138, departure_date: "2022-03-01", arrival_date: "2022-03-15")
    ]
  end
  let(:origin_port) { 'CNSHA' }
  let(:destination_port) { 'NLRTM' }

  before do
    allow(GetIndirectSailings)
      .to(receive(:new).with(
        origin_port: origin_port, destination_port: destination_port, sailings: sailings
      ))
      .and_return(instance_double('GetIndirectSailings'))
    allow(GetDirectSailings)
      .to(receive(:new).with(
        origin_port: origin_port, destination_port: destination_port, sailings: sailings
      ))
      .and_return(instance_double('GetDirectSailings'))
  end

  describe "#direct_sailings_service" do
    it 'creates service object' do
      subject.direct_sailings_service

      expect(GetDirectSailings).to(
        have_received(:new).with(
          origin_port: origin_port, destination_port: destination_port, sailings: sailings
        ).once
      )
    end
  end

  describe "#indirect_sailings_service" do
    it 'creates service object' do
      subject.indirect_sailings_service

      expect(GetIndirectSailings).to(
        have_received(:new).with(
          origin_port: origin_port, destination_port: destination_port, sailings: sailings
        ).once
      )
    end
  end
end
