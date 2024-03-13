class GetSailings
  CRITERIA = {
    cheapest: 'Criteria::GetCheapestSailing',
    fastest: 'Criteria::GetFastestSailing'
  }

  include Dry::Monads[:result]

  attr_reader :sailings, :origin_port, :destination_port, :criteria

  def initialize(origin_port:, destination_port:, sailings:, criteria:)
    @sailings = sailings
    @origin_port = origin_port
    @destination_port = destination_port
    @criteria = criteria
  end

  def call
    return Failure("Invalid origin/destination port!") unless within_valid_endpoints?

    return Failure("Invalid criteria!") unless valid_criteria.include?(criteria.to_sym)

    sailing = CRITERIA[criteria.to_sym].constantize.new(
      origin_port: origin_port, destination_port: destination_port, sailings: sailings
    ).call

    Success(sailing)
  end

  private

  def within_valid_endpoints?
    valid_endpoints.include?(origin_port) && valid_endpoints.include?(destination_port)
  end

  def valid_endpoints
    @valid_endpoints ||=  sailings.map {|sailing| [sailing.origin_port, sailing.destination_port]}.flatten.uniq
  end

  def valid_criteria
    CRITERIA.keys
  end
end
