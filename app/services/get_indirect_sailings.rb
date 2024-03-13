class GetIndirectSailings
  include Dry::Monads[:result]

  attr_reader :sailings, :origin_port, :destination_port

  def initialize(origin_port:, destination_port:, sailings:)
    @sailings = sailings
    @origin_port = origin_port
    @destination_port = destination_port
  end

  def call
    eligible_sailings
  end

  private

  def eligible_sailings
    indirect_sailings = []

    sailings.each do |first_leg|
      if first_leg.origin_port == origin_port
        intermediate_port = first_leg.destination_port
        second_legs = sailings.select do |sailing|
          sailing.origin_port == intermediate_port && sailing.destination_port == destination_port
        end

        second_legs.each do |second_leg|
          indirect_sailings << [first_leg, second_leg] if legs_are_connected?(first_leg, second_leg)
        end
      end
    end

    indirect_sailings
  end

  def legs_are_connected?(first_leg, second_leg)
    second_leg.departure_date.to_date > first_leg.arrival_date.to_date
  end
end
