require 'rails_helper'

describe GetIndirectSailings do
  subject do
    described_class.new(origin_port: origin_port, destination_port: destination_port, sailings: sailings)
  end

  let(:indirect_sailings) do
    [
      Sailing.new(origin_port: 'CNSHA', destination_port: "ESBCN", rate: "456.78", "rate_currency": "EUR", departure_date: "2022-02-01", arrival_date: "2022-03-10"),
      Sailing.new(origin_port: 'ESBCN', destination_port: "NLRTM", rate: "456.78", "rate_currency": "EUR", departure_date: "2022-03-15", arrival_date: "2022-04-01")
    ]
  end
  let(:sailings) do
    [
      *indirect_sailings,
      Sailing.new(origin_port: 'BRSSZ', destination_port: "ESBCN", rate: "97453", "rate_currency": "JPY", jpy: 149.93, departure_date: "2022-02-01", arrival_date: "2022-03-15"),
      Sailing.new(origin_port: 'NLRTM', destination_port: "ESBCN", rate: "97453", "rate_currency": "JPY", jpy: 149.93, departure_date: "2022-02-01", arrival_date: "2022-03-15"),
      Sailing.new(origin_port: 'NLRTM', destination_port: "ESBCN", rate: "97453", "rate_currency": "JPY", jpy: 149.93, departure_date: "2022-02-01", arrival_date: "2022-03-15"),
      Sailing.new(origin_port: 'NLRTM', destination_port: "ESBCN", rate: "97453", "rate_currency": "JPY", jpy: 149.93, departure_date: "2022-02-01", arrival_date: "2022-02-15"),
      Sailing.new(origin_port: 'BRSSZ', destination_port: "NLRTM", rate: "97453", "rate_currency": "JPY", jpy: 149.93, departure_date: "2022-02-20", arrival_date: "2022-03-15")
    ]
  end

  context 'when there is one indirect sailing' do
    let(:origin_port) { 'CNSHA' }
    let(:destination_port) { 'NLRTM' }

    it 'returns all possible indirect sailings' do
      expect(subject.call).to match_array([indirect_sailings])
    end
  end

  context 'when there are disconnected sailings' do
    let(:origin_port) { 'CNSHA' }
    let(:destination_port) { 'NLRTM' }

    let(:indirect_sailings) do
      [
        Sailing.new(origin_port: 'CNSHA', destination_port: "ESBCN", rate: "456.78", "rate_currency": "EUR", departure_date: "2022-02-01", arrival_date: "2022-03-10"),
        Sailing.new(origin_port: 'ESBCN', destination_port: "NLRTM", rate: "456.78", "rate_currency": "EUR", departure_date: "2022-03-15", arrival_date: "2022-04-01")
      ]
    end
    let(:indirect_disconnected_sailings) do
      [
        Sailing.new(origin_port: 'CNSHA', destination_port: "BRSSZ", rate: "97453", "rate_currency": "JPY", jpy: 149.93, departure_date: "2022-02-01", arrival_date: "2022-02-21"),
        Sailing.new(origin_port: 'BRSSZ', destination_port: "NLRTM", rate: "97453", "rate_currency": "JPY", jpy: 149.93, departure_date: "2022-02-10", arrival_date: "2022-03-21"),
      ]
    end
    let(:sailings) do
      [
        *indirect_sailings,
        *indirect_disconnected_sailings,
        Sailing.new(origin_port: 'BRSSZ', destination_port: "ESBCN", rate: "97453", "rate_currency": "JPY", jpy: 149.93, departure_date: "2022-03-09", arrival_date: "2022-04-01"),
        Sailing.new(origin_port: 'ESBCN', destination_port: "BRSSZ", rate: "97453", "rate_currency": "JPY", jpy: 149.93, departure_date: "2022-04-15", arrival_date: "2022-04-29"),
        Sailing.new(origin_port: 'BRSSZ', destination_port: "NLRTM", rate: "97453", "rate_currency": "JPY", jpy: 149.93, departure_date: "2022-02-15", arrival_date: "2022-05-15")
      ]
    end

    it 'returns all possible indirect sailings' do
      expect(subject.call).to match_array([indirect_sailings])
    end
  end

  context 'when there are more than one route' do
    let(:origin_port) { 'CNSHA' }
    let(:destination_port) { 'NLRTM' }

    let(:indirect_sailings) do
      [
        Sailing.new(origin_port: 'CNSHA', destination_port: "ESBCN", rate: "456.78", "rate_currency": "EUR", departure_date: "2022-02-01", arrival_date: "2022-03-10"),
        Sailing.new(origin_port: 'ESBCN', destination_port: "NLRTM", rate: "456.78", "rate_currency": "EUR", departure_date: "2022-03-15", arrival_date: "2022-04-01")
      ]
    end
    let(:second_indirect_sailings) do
      [
        Sailing.new(origin_port: 'CNSHA', destination_port: "BRSSZ", rate: "456.78", "rate_currency": "EUR", departure_date: "2022-02-15", arrival_date: "2022-03-25"),
        Sailing.new(origin_port: 'BRSSZ', destination_port: "NLRTM", rate: "456.78", "rate_currency": "EUR", departure_date: "2022-04-01", arrival_date: "2022-04-28")
      ]
    end
    let(:sailings) do
      [
        *indirect_sailings,
        *second_indirect_sailings,
        Sailing.new(origin_port: 'ESBCN', destination_port: "BRSSZ", rate: "97453", "rate_currency": "JPY", jpy: 149.93, departure_date: "2022-02-01", arrival_date: "2022-02-09"),
        Sailing.new(origin_port: 'NLRTM', destination_port: "ESBCN", rate: "97453", "rate_currency": "JPY", jpy: 149.93, departure_date: "2022-02-10", arrival_date: "2022-02-21"),
        Sailing.new(origin_port: 'BRSSZ', destination_port: "ESBCN", rate: "97453", "rate_currency": "JPY", jpy: 149.93, departure_date: "2022-02-28", arrival_date: "2022-03-15"),
        Sailing.new(origin_port: 'ESBCN', destination_port: "BRSSZ", rate: "97453", "rate_currency": "JPY", jpy: 149.93, departure_date: "2022-03-21", arrival_date: "2022-05-01"),
        Sailing.new(origin_port: 'BRSSZ', destination_port: "NLRTM", rate: "97453", "rate_currency": "JPY", jpy: 149.93, departure_date: "2022-03-12", arrival_date: "2022-06-01")
      ]
    end

    it 'returns all possible indirect sailings' do
      expect(subject.call).to match_array([indirect_sailings, second_indirect_sailings])
    end
  end
end
