# frozen_string_literal: true

module Hibp
  module Helpers
    # Hibp::Helpers::JsonConversion
    #
    #   Used to convert raw API response data to the entity models
    #
    module JsonConversion
      protected

      # Convert raw data to the entity model
      #
      # @param data [Array<Hash>, Hash] - Raw data from response
      #
      def convert(data, &block)
        data.is_a?(Array) ? convert_to_list(data, &block) : convert_to_entity(data, &block)
      end

      private

      def convert_to_list(data, &block)
        data.map { |d| convert_to_entity(d, &block) }
      end

      def convert_to_entity(data)
        attributes = data.each_with_object({}) do |(key, value), hash|
          hash[transform_key(key)] = value
        end

        yield(attributes)
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
