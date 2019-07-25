# frozen_string_literal: true

module Hibp
  # Hibp::Client
  #
  #   Used to fetch data from haveibeenpwned API
  #
  #   Public methods return `Hibp::Query` instance,
  #     which can be configured by applying filters
  #
  #   Data will only be returned if the `#fetch` method is called on the `Hibp::Query` instance.
  #
  #   @see https://haveibeenpwned.com/API/v3
  #
  class Client
    CORE_API_HOST = 'https://haveibeenpwned.com/api/v3'
    PASSWORD_API_HOST = 'https://api.pwnedpasswords.com/range'

    CORE_API_SERVICES = {
      breach: 'breach',
      breaches: 'breaches',
      account_breaches: 'breachedaccount',
      data_classes: 'dataclasses',
      pastes: 'pasteaccount'
    }.freeze

    attr_reader :authorization_header

    # @param api_key [String] - (optional, default: '')
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
    # @return [Hibp::Query]
    #
    def breach(name)
      configure_core_query(:breach, name)
    end

    # Fetch all breached sites in the system
    # Available filters(domain)
    #
    # @note Collection is sorted alphabetically by the title of the breach.
    #
    # @return [Hibp::Query]
    #
    def breaches
      configure_core_query(:breaches)
    end

    # Fetch a list of all breaches a particular account has been involved in.
    # Available filters(truncate, unverified, domain)
    #
    # @param account [String] - The email address to be searched for.
    #
    # @note This method requires authorization. HIBP API key must be used.
    # @note By default, only the name of the breach is returned rather than the complete breach data.
    # @note By default, both verified and unverified breaches are returned when performing a search.
    #
    # @return [Hibp::Query]
    #
    def account_breaches(account)
      configure_core_query(:account_breaches, CGI.escape(account))
    end

    # Fetch all data classes in the system
    #
    # A "data class" is an attribute of a record compromised in a breach.
    # For example, many breaches expose data classes such as "Email addresses" and "Passwords".
    # The values returned by this service are ordered alphabetically in
    # a string array and will expand over time as new breaches expose previously unseen classes of data.
    #
    # @return [Hibp::Query]
    #
    def data_classes
      configure_core_query(:data_classes)
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
    # @param account [String] - The email address to be searched for.
    #
    # @note This is an authenticated API and an HIBP API key must be passed with the request.
    # @note The collection is sorted chronologically with the newest paste first.
    #
    # @return [Hibp::Query]
    #
    def pastes(account)
      configure_core_query(:pastes, CGI.escape(account))
    end

    # Search pwned passwords
    #
    # @param password [String] -
    #   The value of the source password being searched for
    #
    # @note The API will respond with include the suffix of every hash beginning
    #       with the specified password prefix(five first chars of the password hash),
    #       and with a count of how many times it appears in the data set.
    #
    # @return [Hibp::Query]
    #
    def passwords(password)
      configure_password_query(password)
    end

    private

    def configure_password_query(password)
      pwd_hash = ::Digest::SHA1.hexdigest(password).upcase
      endpoint = "#{PASSWORD_API_HOST}/#{pwd_hash[0..4]}"

      Query.new(endpoint: endpoint, parser: Parsers::Password.new)
    end

    def configure_core_query(service, parameter = nil)
      endpoint = resolve_endpoint(service, parameter)
      parser = resolve_parser(service)

      Query.new(endpoint: endpoint, parser: parser, headers: @authorization_header)
    end

    def resolve_endpoint(service, parameter)
      endpoint = "#{CORE_API_HOST}/#{CORE_API_SERVICES[service]}"

      parameter ? "#{endpoint}/#{parameter}" : endpoint
    end

    def resolve_parser(service)
      breach_services = %i[breach breaches account_bereaches]

      case service
      when ->(n) { breach_services.include?(n) }
        Parsers::Breach.new
      when :pastes
        Parsers::Paste.new
      when :data_classes
        Parsers::Json.new
      end
    end
  end
end
