class Criteria::GetCheapestSailing
  attr_reader :route_information, :sailings, :origin_port, :destination_port, :direct_sailings_service, :indirect_sailings_service

  def initialize(route_information:)
    @route_information = route_information
  end

  def call
    cheapest_sailing
  end

  private

  def cheapest_sailing
    cheapest_indirect_sailing = @route_information.indirect_sailings_service.call.min_by do |pair|
      pair.sum(&:rate_in_euro)
    end
    cheapest_sailing = @route_information.direct_sailings_service.call.min_by(&:rate_in_euro)

    if cheapest_indirect_sailing
      cheapest_sailing = cheapest_indirect_sailing unless cheapest_sailing.rate_in_euro < cheapest_indirect_sailing.sum(&:rate_in_euro)
    end

    cheapest_sailing
  end

  # def within_valid_endpoints?
  #   valid_endpoints.include?(origin_port) && valid_endpoints.include?(destination_port)
  # end

  # def direct_sailings
  #   @direct_sailings ||= direct_sailings_service.call
  # end

  # def indirect_sailings
  #   @indirect_sailings ||= indirect_sailings_service.call
  # end

  # def valid_endpoints
  #   @valid_endpoints ||=  sailings.map {|sailing| [sailing.origin_port, sailing.destination_port]}.flatten.uniq
  # end
end
