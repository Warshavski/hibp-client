# frozen_string_literal: true

module Hibp
  module Breaches
    # Hibp::Breaches::Converter
    #
    #   Used to convert raw API response data to the breach entity or
    #     array of the entities in case if response data contains multiple breaches
    #
    class Converter
      include ::Hibp::DataConversion

      # Convert raw data to the breach entity
      #
      # @param data [Array<Hash>, Hash] -
      #   Raw data that represents breach model
      #
      # @see https://haveibeenpwned.com/API/v3 (The breach model, Sample breach response)
      #
      # @return [Array<Hibp::Breach>, Hibp::Breach]
      #
      def convert(data)
        super { |attributes| ::Hibp::Breach.new(attributes) }
      end
    end
  end
end
