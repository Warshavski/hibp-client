# frozen_string_literal: true

module Hibp
  module Parsers
    # Hibp::Parsers::Paste
    #
    #   Used to convert raw API response data to the array of the paste entities
    #
    class Paste < Json
      # Convert raw data to the pastes entities
      #
      # @param response [Faraday::Response] -
      #   Response that contains raw data for conversion
      #
      # @see https://haveibeenpwned.com/API/v3 (The paste model, Sample paste response)
      #
      # @return [Array<Hibp::Paste>]
      #
      def parse_response(response)
        super(response) { |attributes| Models::Paste.new(attributes) }
      end
    end
  end
end
