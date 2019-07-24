# frozen_string_literal: true

module Hibp
  module Models
    # Hibp::Models::Password
    #
    #   Represents password by the suffix of and
    #   a count of how many times it appears in the data set
    #
    class Password
      include Helpers::AttributeAssignment

      attr_accessor :suffix, :occurrences

      # @param attributes [Hash]
      #
      # @option attributes [String] :suffix -
      #   Password suffix(password hash without first five symbols)
      #
      # @option attributes [Integer] :occurrences -
      #   Count of how many times suffix appears in the data set
      #
      def initialize(attributes)
        assign_attributes(attributes)
      end
    end
  end
end
