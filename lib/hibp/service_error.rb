# frozen_string_literal: true

module Hibp
  # Hibp::ServiceError
  #
  #   Used to represent an error that may occur when performing a request to the API
  #
  class ServiceError < StandardError
    attr_reader :data, :raw_body, :status_code

    # @param message [String] - (optional, '') Message to describe an error
    # @param params [Hash] - (optional, {}) Additional error information
    #
    # @option params [String] :data -
    #   A JSON formatted error object that provides more details about the specifics of the error
    #
    # @option params [String] :raw_body -
    #   Raw body from response
    #
    # @option params [String] :status_code  -
    #   Http status code
    #
    def initialize(message = '', params = {})
      @data           = params[:data]
      @raw_body       = params[:raw_body]
      @status_code    = params[:status_code]

      super(message)
    end

    def to_s
      "#{super} #{instance_variables_to_s}"
    end

    private

    def instance_variables_to_s
      attr_values = %i[data raw_body status_code].map do |attr|
        attr_value = send(attr)

        "@#{attr}=#{attr_value.inspect}"
      end

      attr_values.join(', ')
    end
  end
end
