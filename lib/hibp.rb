# frozen_string_literal: true

require 'faraday'
require 'oj'

require 'hibp/breach'
require 'hibp/breaches/converter'
require 'hibp/client'
require 'hibp/parser'
require 'hibp/request'
require 'hibp/service_error'

require 'hibp/version'

module Hibp
  class Error < StandardError; end
  # Your code goes here...
end
