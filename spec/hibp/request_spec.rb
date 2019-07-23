# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hibp::Request do
  let!(:endpoint)   { 'test' }
  let!(:api_host)   { 'https://haveibeenpwned.com/api/v3' }

  describe '#get' do
    subject { described_class.new(endpoint: endpoint).get }

    it 'surfaces client request exceptions as a Hibp::ServiceError' do
      exception = Faraday::Error::ClientError.new('the server responded with status 500')

      stub_request(:get, "#{api_host}/#{endpoint}").to_raise(exception)

      expect { subject }.to raise_error(Hibp::ServiceError)
    end

    it 'surfaces an unparseable response body as a Hibp::ServiceError' do
      response_values = { status: 503, headers: {}, body: '[foo]' }

      exception = Faraday::Error::ClientError.new('the server responded with status 503', response_values)

      stub_request(:get, "#{api_host}/#{endpoint}").to_raise(exception)

      expect { subject }.to raise_error(Hibp::ServiceError)
    end
  end

  describe '#handle_error' do
    it "includes status and raw body even when json can't be parsed" do
      response_values = { status: 503, headers: {}, body: 'A non JSON response' }

      exception = Faraday::Error::ClientError.new('the server responded with status 503', response_values)

      begin
        described_class.new(endpoint: endpoint).send(:handle_error, exception)
      rescue StandardError => boom
        expect(boom.status_code).to eq 503
        expect(boom.raw_body).to eq 'A non JSON response'
      end
    end
  end
end
