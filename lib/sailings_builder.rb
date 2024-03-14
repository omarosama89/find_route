require 'json'

class SailingsBuilder
  attr_reader :sailings, :rates, :exchange_rates

  def initialize(filepath = 'response.json')
    file = File.read(filepath)
    data = JSON.parse(file)

    @sailings = data['sailings']
    @rates = data['rates']
    @exchange_rates = data['exchange_rates']
  end

  def call
    sailings.map do |sailing|
      Sailing.new **sailing, **rate_attributes(sailing['sailing_code']), **rate_exchange_attributes(sailing['departure_date'])
    end
  end

  private

  def rate_attributes(sailing_code)
    rates.find {|rate| rate['sailing_code'] == sailing_code}
  end

  def rate_exchange_attributes(departure_date)
    exchange_rates[departure_date]
  end
end
