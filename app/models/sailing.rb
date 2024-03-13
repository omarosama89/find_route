class Sailing
  attr_accessor :sailing_code, :origin_port, :destination_port, :departure_date, :arrival_date, :rate,
              :rate_currency, :usd, :jpy

  def initialize(attributes ={})
    attributes.each do |key, val|
      instance_variable_set("@#{key}", val)
    end
  end

  def rate_in_euro
    (rate.to_f / (exchange_rates[rate_currency.downcase.to_sym] || 1)).round(2)
  end

  def days_for_arrival
    (arrival_date.to_date - departure_date.to_date).to_i
  end

  def to_json
    {
      "origin_port": origin_port,
      "destination_port": destination_port,
      "departure_date": departure_date,
      "arrival_date": arrival_date,
      "sailing_code": sailing_code,
      "rate": rate,
      "rate_currency": rate_currency
    }.to_json
  end

  private

  def exchange_rates
    {
      usd: usd,
      jpy: jpy
    }
  end
end
