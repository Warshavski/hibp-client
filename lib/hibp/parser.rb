# frozen_string_literal: true

module Hibp
  # Hibp::Parser
  #
  #   Used to parse API response and transform(convert) this
  #     raw data to the model specified by converter
  #
  class Parser
    # @param converter [Object] - (optional, default: nil)
    #   Converter that used to convert complex
    #   raw response data to the particular model representation.
    #
    #   If converter not set than parser returns raw data
    #   (useful in cases when response returns array of strings)
    #
    def initialize(converter = nil)
      @converter = converter
    end

    # Parse API response
    #
    # @param response []
    #
    # @raise [Hibp::ServiceError]
    #
    def parse_response(response)
      return nil if empty_response?(response)

      begin
        _, body = prepare_response(response)

        @converter ? @converter.convert(body) : body
      rescue Oj::ParseError
        raise_error(response.body)
      end
    end

    private

    def empty_response?(response)
      response.body.nil? || response.body.empty?
    end

    def prepare_response(response)
      headers = response.headers
      body = Oj.load(response.body, symbolize_keys: true)

      [headers, body]
    end

    def raise_error(payload)
      error = ServiceError.new(
        "Unparseable response: #{payload}",
        title: 'UNPARSEABLE_RESPONSE', status_code: 500
      )

      raise error
    end
  end
end
