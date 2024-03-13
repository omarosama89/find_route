class Criteria::GetFastestSailing
  attr_reader :sailings, :origin_port, :destination_port

  def initialize(origin_port:, destination_port:, sailings:)
    @sailings = sailings
    @origin_port = origin_port
    @destination_port = destination_port
  end

  def call
    fastest_sailing
  end

  private

  def fastest_sailing
    fastest_indirect_sailing = indirect_sailings.min_by do |first_leg, second_leg|
      (second_leg.arrival_date.to_date - first_leg.departure_date.to_date).to_i
    end

    fastest_sailing = direct_sailings.min_by(&:days_for_arrival)

    if fastest_indirect_sailing
      fastest_sailing = fastest_indirect_sailing unless fastest_sailing.days_for_arrival < (fastest_indirect_sailing[1].arrival_date.to_date - fastest_indirect_sailing[0].departure_date.to_date).to_i
    end

    fastest_sailing
  end

  def within_valid_endpoints?
    valid_endpoints.include?(origin_port) && valid_endpoints.include?(destination_port)
  end

  def direct_sailings
    @direct_sailings ||= GetDirectSailings.new(
      origin_port: origin_port, destination_port: destination_port, sailings: sailings
    ).call
  end

  def indirect_sailings
    @indirect_sailings ||= GetIndirectSailings.new(
      origin_port: origin_port, destination_port: destination_port, sailings: sailings
    ).call
  end

  def valid_endpoints
    @valid_endpoints ||=  sailings.map {|sailing| [sailing.origin_port, sailing.destination_port]}.flatten.uniq
  end
end
