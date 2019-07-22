# frozen_string_literal: true

module Hibp
  module Breaches
    # Hibp::Breaches::Converter
    #
    #   Used to convert raw API response data to the breach entity or
    #     array of the entities in case if response data contains multiple breaches
    #
    class Converter
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
        data.is_a?(Array) ? convert_to_list(data) : convert_to_entity(data)
      end

      private

      def convert_to_list(data)
        data.map(&method(:convert_to_entity))
      end

      def convert_to_entity(data)
        attributes = data.each_with_object({}) do |(key, value), hash|
          hash[transform_key(key)] = value
        end

        ::Hibp::Breach.new(attributes)
      end

      def transform_key(key)
        underscore(key.to_s).to_sym
      end

      def underscore(camel_cased_word)
        camel_cased_word.gsub(/::/, '/')
                        .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
                        .gsub(/([a-z\d])([A-Z])/, '\1_\2')
                        .tr('-', '_')
                        .downcase
      end
    end
  end
end
