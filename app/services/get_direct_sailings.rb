class GetDirectSailings
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
    @eligible_sailings ||= sailings.select do |sailing|
      sailing.origin_port == origin_port && sailing.destination_port == destination_port
    end
  end
end
