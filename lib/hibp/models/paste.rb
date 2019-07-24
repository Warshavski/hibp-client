# frozen_string_literal: true

module Hibp
  module Models
    # Hibp::Models::Paste
    #
    #   Used to construct a "paste" model
    #
    #   A "paste" is information that has been "pasted" to a publicly facing
    #   website designed to share content such as Pastebin.
    #
    #   These services are favoured by hackers due to the ease of anonymously
    #   sharing information and they're frequently the first place a breach appears.
    #
    #   @note In the future, these attributes may expand without the API being versioned.
    #
    #   @see https://haveibeenpwned.com/FAQs
    #
    class Paste
      include Helpers::AttributeAssignment

      attr_accessor :source, :id, :title, :date, :email_count

      # @param attributes [Hash]
      #
      # @option attributes [String] :source -
      #   The paste service the record was retrieved from.
      #   Current values are:
      #     - Pastebin
      #     - Pastie
      #     - Slexy
      #     - Ghostbin
      #     - QuickLeak
      #     - JustPaste
      #     - AdHocUrl
      #     - PermanentOptOut
      #     - OptOut
      #
      # @option attributes [String] :id -
      #   The ID of the paste as it was given at the source service.
      #   Combined with the "Source" attribute, this can be used to resolve the URL of the paste.
      #
      # @option attributes [String] :title -
      #   The title of the paste as observed on the source site.
      #   This may be null.
      #
      # @option attributes [String] :date -
      #   The date and time (precision to the second) that the paste was posted.
      #   This is taken directly from the paste site when this information is
      #   available but may be null if no date is published.
      #
      # @option attributes [Integer] :email_count -
      #   The number of emails that were found when processing the paste.
      #   Emails are extracted by using the regular expression:
      #   \b+(?!^.{256})[a-zA-Z0-9\.\-_\+]+@[a-zA-Z0-9\.\-_]+\.[a-zA-Z]+\b
      #
      def initialize(attributes)
        assign_attributes(attributes)
      end
    end
  end
end
