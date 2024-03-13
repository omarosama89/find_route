class RoutesController < ApplicationController
  def index
    result = GetSailings.new(
      origin_port: origin_port, destination_port: destination_port, sailings: sailings, criteria: criteria
    ).call

    if result.success?
      render json: result.value!.to_json, status: :ok
    else
      render json: { error: result.failure }, status: :bad_request
    end
  end

  private

  def origin_port
    params[:origin_port]
  end

  def destination_port
    params[:destination_port]
  end

  def sailings
    SailingsBuilder.new.call
  end

  def criteria
    params[:criteria] || 'cheapest'
  end
end
