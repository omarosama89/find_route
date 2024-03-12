class GetCheapestEndpoint
  include Dry::Monads[:result]

  attr_reader :sailings, :origin_port, :destination_port

  def initialize(origin_port:, destination_port:, sailings:)
    @sailings = sailings
    @origin_port = origin_port
    @destination_port = destination_port
  end

  def call
    return Failure("Invalid origin/destination port") unless within_valid_endpoints?

    Success(eligible_sailings.min_by(&:rate_in_euro))
  end

  private

  def eligible_sailings
    @eligible_sailings ||= sailings.select do |sailing|
      sailing.origin_port == origin_port && sailing.destination_port == destination_port
    end
  end

  def within_valid_endpoints?
    valid_endpoints.include?(origin_port) && valid_endpoints.include?(destination_port)
  end

  def valid_endpoints
    @valid_endpoints ||=  sailings.map {|sailing| [sailing.origin_port, sailing.destination_port]}.flatten.uniq
  end
end
