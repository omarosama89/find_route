class Criteria::GetCheapestSailing
  attr_reader :sailings, :origin_port, :destination_port

  def initialize(origin_port:, destination_port:, sailings:)
    @sailings = sailings
    @origin_port = origin_port
    @destination_port = destination_port
  end

  def call
    cheapest_sailing
  end

  private

  def cheapest_sailing
    cheapest_indirect_sailing = indirect_sailings.min_by do |pair|
      pair.sum(&:rate_in_euro)
    end
    cheapest_sailing = direct_sailings.min_by(&:rate_in_euro)

    if cheapest_indirect_sailing
      cheapest_sailing = cheapest_indirect_sailing unless cheapest_sailing.rate_in_euro < cheapest_indirect_sailing.sum(&:rate_in_euro)
    end

    cheapest_sailing
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
