# frozen_string_literal: true

module Hibp
  module Parsers
    # Hibp::Parsers::Json
    #
    #   Used to parse API JSON response and transform(convert) this
    #     raw data to the model specified by converter
    #
    class Json
      include Helpers::JsonConversion

      # Parse API response
      #
      # @param response [Faraday::Response] -
      #   Response that contains raw data for conversion
      #
      # @yield [attributes] - (optional, default: nil)
      #   Converter that used to convert complex
      #   raw response data to the particular model representation.
      #
      # @note If block with conversion not set than parser returns raw data
      #   (useful in cases when response returns array of strings)
      #
      # @raise [Hibp::ServiceError]
      #
      def parse_response(response, &block)
        return nil if empty_response?(response)

        begin
          _, body = prepare_response(response)

          block_given? ? convert(body, &block) : body
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
end
