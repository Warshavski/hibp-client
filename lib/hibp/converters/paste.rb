# frozen_string_literal: true

module Hibp
  module Converters
    # Hibp::Converters::Paste
    #
    #   Used to convert raw API response data to the array of the paste entities
    #
    class Paste
      include Helpers::JsonConversion

      # Convert raw data to the pastes entities
      #
      # @param data [Array<Hash>] -
      #   Raw data that represents pastes models
      #
      # @see https://haveibeenpwned.com/API/v3 (The paste model, Sample paste response)
      #
      # @return [Array<Hibp::Paste>]
      #
      def convert(data)
        super { |attributes| Models::Paste.new(attributes) }
      end
    end
  end
end
