class RouteInformation
  attr_reader :sailings, :origin_port, :destination_port,
              :direct_sailings_service, :indirect_sailings_service

  def initialize(attributes={})
    attributes.each do |key, val|
      instance_variable_set("@#{key}", val)
    end
  end

  def direct_sailings_service
    GetDirectSailings.new(origin_port: origin_port, destination_port: destination_port, sailings: sailings)
  end

  def indirect_sailings_service
    GetIndirectSailings.new(origin_port: origin_port, destination_port: destination_port, sailings: sailings)
  end
end
