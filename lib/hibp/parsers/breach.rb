# frozen_string_literal: true

module Hibp
  module Parsers
    # Hibp::Parsers::Breach
    #
    #   Used to convert raw API response data to the breach entity or
    #     array of the entities in case if response data contains multiple breaches
    #
    class Breach < Json

      # Convert raw data to the breach entity
      #
      # @param response [Faraday::Response] -
      #   Response that contains raw data for conversion
      #
      # @see https://haveibeenpwned.com/API/v3 (The breach model, Sample breach response)
      #
      # @return [Array<Hibp::Breach>, Hibp::Breach]
      #
      def parse_response(response)
        super(response) do |attributes|
          Models::Breach.new(convert_dates!(attributes))
        end
      end

      private

      def convert_dates!(attributes)
        %i[modified_date breach_date added_date].each do |attr_key|
          next if attributes[attr_key].nil?

          type = attr_key == :breach_date ? Date : Time

          attributes[attr_key] = type.parse(attributes[attr_key])
        end

        attributes
      end
    end
  end
end
