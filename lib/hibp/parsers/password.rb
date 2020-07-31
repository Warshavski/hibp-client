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

      # Convert API response raw data to the passwords models. If occurrences of
      # a hash suffix are 0 then it's fake data added by the add_padding option
      #
      # @param response [] -
      #   Contains the suffix of every hash beginning with the specified prefix,
      #   followed by a count of how many times it appears in the data set
      #
      # @return [Array<Hibp::Models::Password>]
      #
      def parse_response(response)
        data = response.body

        data.split(ROWS_SPLITTER).inject([]) do |array, row|
          suffix, occurrences = row.split(ATTRIBUTES_SPLITTER)

          if occurrences.to_i > 0
            array <<  Models::Password.new(suffix: suffix, occurrences: occurrences.to_i)
          end

          array
        end
      end
    end
  end
end
