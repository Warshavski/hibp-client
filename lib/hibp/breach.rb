# frozen_string_literal: true

module Hibp
  # Hibp::Breach
  #
  #   Used to construct a "breach" model
  #
  #   A "breach" is an instance of a system having been compromised by an
  #   attacker and the data disclosed.
  #
  #   For example, Adobe was a breach, Gawker was a breach etc.
  #
  #   A "breach" is an incident where data is inadvertently exposed in a vulnerable system,
  #   usually due to insufficient access controls or security weaknesses in the software.
  #
  #   @see https://haveibeenpwned.com/FAQs
  #
  class Breach
    include Hibp::AttributeAssignment

    attr_accessor :name, :title, :domain, :description, :logo_path,
                  :data_classes, :pwn_count,
                  :breach_date, :added_date, :modified_date,
                  :is_verified, :is_fabricated, :is_sensitive, :is_retired, :is_spam_list

    # @param attributes [Hash] - Attributes in a hash
    #
    # @option attributes [String] :name  -
    #   A name representing the breach which is unique across all other breaches.
    #   This value never changes and may be used to name dependent assets
    #   (such as images) but should not be shown directly to end users
    #   (see the "title" attribute instead).
    #
    # @option attributes [String] :title -
    #   A descriptive title for the breach suitable for displaying to end users.
    #   It's unique across all breaches but individual values may change in the future
    #   (i.e. if another breach occurs against an organisation already in the system).
    #   If a stable value is required to reference the breach, refer to the "Name" attribute instead.
    #
    # @option attributes [String] :domain -
    #   The domain of the primary website the breach occurred on.
    #   This may be used for identifying other assets external systems may have for the site.
    #
    # @option attributes [Date] :breach_date -
    #   The date (with no time) the breach originally occurred on in ISO 8601 format.
    #   This is not always accurate — frequently breaches are discovered and reported long after the original incident.
    #   Use this attribute as a guide only.
    #
    # @option attributes [DateTime] :added_date -
    #   The date and time (precision to the minute) the breach was added to the system in ISO 8601 format.
    #
    # @option attributes [DateTime] :modified_date -
    #   The date and time (precision to the minute) the breach was modified in ISO 8601 format.
    #   This will only differ from the AddedDate attribute if other attributes
    #   represented here are changed or data in the breach itself is changed
    #   (i.e. additional data is identified and loaded).
    #   It is always either equal to or greater then the AddedDate attribute, never less than.
    #
    # @option attributes [Integer] :pwn_count -
    #   The total number of accounts loaded into the system.
    #   This is usually less than the total number reported by the media due to
    #   duplication or other data integrity issues in the source data.
    #
    # @option attributes [String] :description -
    #   Contains an overview of the breach represented in HTML markup.
    #   The description may include markup such as emphasis and strong tags as well as hyperlinks.
    #
    # @option attributes [Array<String>] :data_classes -
    #   This attribute describes the nature of the data compromised in the breach and
    #   contains an alphabetically ordered string array of impacted data classes.
    #
    # @option attributes [Boolean] :is_verified -
    #   Indicates that the breach is considered unverified.
    #   An unverified breach may not have been hacked from the indicated website.
    #   An unverified breach is still loaded into HIBP when there's
    #   sufficient confidence that a significant portion of the data is legitimate.
    #
    # @option attributes [Boolean] :is_fabricated -
    #   Indicates that the breach is considered fabricated.
    #   A fabricated breach is unlikely to have been hacked from the
    #   indicated website and usually contains a large amount of manufactured data.
    #   However, it still contains legitimate email addresses and asserts that
    #   the account owners were compromised in the alleged breach.
    #
    # @option attributes [Boolean] :is_sensitive -
    #   Indicates if the breach is considered sensitive.
    #   The public API will not return any accounts for a breach flagged as sensitive.
    #
    # @option attributes [Boolean] :is_retired -
    #   Indicates if the breach has been retired.
    #   This data has been permanently removed and will not be returned by the API.
    #
    # @option attributes [Boolean] :is_spam_list -
    #   Indicates if the breach is considered a spam list.
    #   This flag has no impact on any other attributes but
    #   it means that the data has not come as a result of a security compromise.
    #
    # @option attributes [String] :logo_path -
    #   A URI that specifies where a logo for the breached service can be found.
    #   Logos are always in PNG format.
    #
    # @raise [ArgumentError]
    # @raise [UnknownAttributeError]
    #
    def initialize(attributes)
      assign_attributes(attributes)
    end

    %i[verified fabricated sensitive retired spam_list].each do |method|
      define_method("#{method}?") { public_send("is_#{method}") }
    end
  end
end
