class Criteria::GetFastestSailing
  attr_reader :route_information

  def initialize(route_information:)
    @route_information = route_information
  end

  def call
    fastest_sailing
  end

  private

  def fastest_sailing
    fastest_indirect_sailing = route_information.indirect_sailings_service.call.min_by do |first_leg, second_leg|
      (second_leg.arrival_date.to_date - first_leg.departure_date.to_date).to_i
    end

    fastest_sailing = route_information.direct_sailings_service.call.min_by(&:days_for_arrival)

    if fastest_indirect_sailing
      fastest_sailing = fastest_indirect_sailing unless fastest_sailing.days_for_arrival < (fastest_indirect_sailing[1].arrival_date.to_date - fastest_indirect_sailing[0].departure_date.to_date).to_i
    end

    fastest_sailing
  end
end
