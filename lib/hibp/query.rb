# frozen_string_literal: true

module Hibp
  # Hibp::Query
  #
  #   Used to build and execute request to the HIBP API
  #
  class Query
    attr_reader :endpoint, :headers, :parser

    # @param endpoint [String] -
    #   A specific API endpoint to call appropriate method
    #
    # @param headers [Hash] -
    #   Specific request headers
    #
    # @param parser [Hibp::Parser] -
    #   A tool to parse and convert data into appropriate models
    #
    def initialize(endpoint:, headers: {}, parser: Parser.new)
      @endpoint = endpoint
      @headers = headers

      @parser = parser
      @query_params = {}
    end

    # Apply query filtration
    #
    # @param filters [Hash] - (optional, default: {})
    #   Additional filtration params
    #
    # @option filters [String] :domain -
    #   Filters the result set to only breaches against the domain specified.
    #   It is possible that one site (and consequently domain), is compromised on multiple occasions.
    #   (breaches and account_breaches queries)
    #
    # @option filters [Boolean] :truncate - (default: true)
    #   Short/Full data switcher(only name or full breach data)
    #   (only for account_breaches query)
    #
    # @option filters [Boolean] :unverified -
    #   Returns breaches that have been flagged as "unverified".
    #   (only for account_breaches query)
    #
    # @return [Hibp::Query]
    #
    def where(filters = {})
      tap do
        @query_params.merge!(convert_filters(filters))
      end
    end

    # Perform query execution(data fetching)
    #
    # @return [
    #   Array<String>,
    #   Array<Hibp::Models::Breach>,
    #   Array<Hibp::Models::Paste>,
    #   Hibp::Models::Breach
    # ]
    #
    def fetch
      confugure_request.get(headers: @headers, params: @query_params)
    end

    private

    def confugure_request
      Request.new(parser: @parser, endpoint: @endpoint)
    end

    def convert_filters(params)
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
