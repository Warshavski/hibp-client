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
    def initialize(api_key = '')
      @authorization_header = { 'hibp-api-key' => api_key }
    end

    # Find a single breached site
    #
    # @param name [String] - Breach name
    #
    # @note This is the stable value which may or may not be the same as the breach "title" (which can change).
    #
    # @raise [Hibp::ServiceError]
    # @return [Hibp::Breach]
    #
    def find_breach(name)
      breach_request("breach/#{name}").get
    end

    # Fetch all breached sites in the system
    #
    # @param filters [Hash] - (optional, default: {})
    #   Additional filtration params
    #
    # @option filters [String] :domain -
    #   Filters the result set to only breaches against the domain specified.
    #   It is possible that one site (and consequently domain), is compromised on multiple occasions.
    #
    # @note Collection is sorted alphabetically by the title of the breach.
    #
    # @raise [Hibp::ServiceError]
    # @return [Array<Hibp::Breach>]
    #
    def fetch_breaches(filters = {})
      breach_request('breaches')
        .get(params: convert_params(filters))
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
      simple_request('dataclasses').get
    end

    # Search an account for pastes.
    #
    # HIBP searches through pastes that are broadcast by the @dumpmon Twitter
    # account and reported as having emails that are a potential indicator of a breach.
    #
    # Finding an email address in a paste does not immediately mean it has been
    # disclosed as the result of a breach. Review the paste and determine if your
    # account has been compromised then take appropriate action such as changing passwords.
    #
    # @param account [String] -
    #   The URL encoded email address to be searched for.
    #
    # @note This is an authenticated API and an HIBP API key must be passed with the request.
    # @note The collection is sorted chronologically with the newest paste first.
    #
    # @raise [Hibp::ServiceError]
    # @return [Array<Hibp::Paste>]
    #
    def fetch_account_pastes(account)
      paste_request("pasteaccount/#{account}")
        .get(headers: @authorization_header)
    end

    # Fetch a list of all breaches a particular account has been involved in.
    #
    # @param account [String]  -
    #   The URL encoded email address to be searched for.
    #
    # @param params [Hash] - (optional, default: {})
    #   Additional filtration and data customization params
    #
    # @option params [Boolean] :truncate - (default: true)
    #   Full/Short data switcher(only name or full breach data)
    #
    # @option params [Boolean] :unverified -
    #   Returns breaches that have been flagged as "unverified".
    #
    # @option params [String] :domain -
    #   Filters the result set to only breaches against the domain specified.
    #   It is possible that one site (and consequently domain), is compromised on multiple occasions.
    #
    # @note This method requires authorization. HIBP API key must be used.
    # @note By default, only the name of the breach is returned rather than the complete breach data.
    # @note By default, both verified and unverified breaches are returned when performing a search.
    #
    # @raise [Hibp::ServiceError]
    # @return [Array<Hibp::Breach>]
    #
    def fetch_account_breaches(account, params = {})
      breach_request("breachedaccount/#{account}")
        .get(params: convert_params(params), headers: @authorization_header)
    end

    private

    def simple_request(endpoint)
      confugure_request { { endpoint: endpoint } }
    end

    def breach_request(endpoint)
      confugure_request do
        { endpoint: endpoint, parser: Parser.new(Breaches::Converter.new) }
      end
    end

    def paste_request(endpoint)
      confugure_request do
        { endpoint: endpoint, parser: Parser.new(Pastes::Converter.new) }
      end
    end

    def confugure_request
      Request.new(yield)
    end

    def convert_params(params)
      mappings = {
        truncate: 'truncateResponse',
        domain: 'domain',
        unverified: 'includeUnverified'
      }

      params.each_with_object({}) do |(origin_key, value), acc|
        acc[mappings.fetch(origin_key)] = value
      end
    end
  end
end
