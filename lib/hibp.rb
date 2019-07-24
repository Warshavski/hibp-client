# frozen_string_literal: true

require 'faraday'
require 'oj'

require 'hibp/helpers/attribute_assignment'
require 'hibp/helpers/json_conversion'

require 'hibp/models/breach'
require 'hibp/models/paste'

require 'hibp/converters/breach'
require 'hibp/converters/paste'

require 'hibp/query'

require 'hibp/client'

require 'hibp/parser'
require 'hibp/request'

require 'hibp/service_error'

require 'hibp/version'

module Hibp
  class Error < StandardError; end
  # Your code goes here...
end
