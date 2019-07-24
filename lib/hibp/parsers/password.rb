# frozen_string_literal: true

module Hibp
  module Parsers
    # Parsers::Password
    #
    #   Used to parse raw data and convert it to the password models
    #
    class Password
      ROWS_SPLITTER = "\r\n"
      ATTRIBUTES_SPLITTER = ':'

      # Convert API response raw data to the passwords models.
      #
      # @param response [] -
      #   Contains the suffix of every hash beginning with the specified prefix,
      #   followed by a count of how many times it appears in the data set
      #
      # @return [Array<Hibp::Models::Password>]
      #
      def parse_response(response)
        data = response.body

        data.split(ROWS_SPLITTER).map(&method(:convert_to_password))
      end

      private

      def convert_to_password(row)
        suffix, occurrences = row.split(ATTRIBUTES_SPLITTER)

        Models::Password.new(suffix: suffix, occurrences: occurrences.to_i)
      end
    end
  end
end
