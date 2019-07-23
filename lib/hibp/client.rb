# frozen_string_literal: true

module Hibp
  # Hibp::Client
  #
  #   Used to fetch data from haveibeenpwned API
  #
  #   @see https://haveibeenpwned.com/API/v3
  #
  class Client

    # @param api_key [String] - (optional, default: nil)
    #   Authorisation is required for all APIs that enable searching HIBP by email address,
    #   namely retrieving all breaches for an account and retrieving all pastes for an account.
    #   An HIBP subscription key is required to make an authorised call and can be obtained on the API key page.
    #   The key is then passed in a "hibp-api-key" header:
    #
    # @see https://haveibeenpwned.com/API/Key
    #
    def initialize(api_key = nil)
      @api_key = api_key
    end

    # Find a single breached site
    #
    # @note This is the stable value which may or may not be the same as the breach "title" (which can change).
    #
    # @param name [String] - Breach name
    #
    # @raise [Hibp::ServiceError]
    # @return [Hibp::Breach]
    #
    def find_breach(name)
      breach_request("breach/#{name}")
    end

    # Fetch all breached sites in the system
    #
    # @note Collection is sorted alphabetically by the title of the breach.
    #
    # @param domain [String]  -
    #   Filters the result set to only breaches against the domain specified.
    #   It is possible that one site (and consequently domain), is compromised on multiple occasions.
    #
    # @raise [Hibp::ServiceError]
    # @return [Array<Hibp::Breach>]
    #
    def fetch_breaches(domain = nil)
      endpoint = domain ? "breaches?domain=#{domain}" : 'breaches'

      breach_request(endpoint)
    end

    # Fetch all data classes in the system
    #
    # A "data class" is an attribute of a record compromised in a breach.
    # For example, many breaches expose data classes such as "Email addresses" and "Passwords".
    # The values returned by this service are ordered alphabetically in
    # a string array and will expand over time as new breaches expose previously unseen classes of data.
    #
    # @raise [Hibp::ServiceError]
    # @return [Array<String>]
    #
    def fetch_data_classes
      Request.new(endpoint: 'dataclasses').get
    end

    private

    def breach_request(endpoint)
      parser = Parser.new(Breaches::Converter.new)

      Request.new(endpoint: endpoint, parser: parser).get
    end
  end
end
