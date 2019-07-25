# frozen_string_literal: true

require 'digest'
require 'faraday'
require 'oj'

require 'hibp/helpers/attribute_assignment'
require 'hibp/helpers/json_conversion'

require 'hibp/models/breach'
require 'hibp/models/paste'
require 'hibp/models/password'

require 'hibp/parsers/json'
require 'hibp/parsers/breach'
require 'hibp/parsers/password'
require 'hibp/parsers/paste'

require 'hibp/client'
require 'hibp/request'
require 'hibp/query'

require 'hibp/service_error'

require 'hibp/version'

module Hibp
  class Error < StandardError; end
  # Your code goes here...
end
