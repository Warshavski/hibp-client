# frozen_string_literal: true

RSpec.describe Hibp::Parsers::Json do
  describe '#parse_response' do
    context 'when block not set' do
      subject { described_class.new.parse_response(response) }

      context 'when response body is empty' do
        let(:response) { double('response', body: nil, headers: nil) }

        it { is_expected.to be_nil }
      end

      context 'when response body contains array of strings' do
        let(:raw_data) { '["wat", "so", "hey"]' }
        let(:response) { double('response', body: raw_data, headers: nil) }

        it { is_expected.to eq(%w[wat so hey]) }
      end

      context 'when response body is unparseable' do
        let(:raw_data) { 'wat response' }
        let(:response) { double('response', body: raw_data, headers: nil) }

        it { expect { subject }.to raise_error Hibp::ServiceError }
      end
    end

    context 'when block is set' do
      subject { described_class.new.parse_response(response) { |attrs| attrs } }

      let(:raw_data) { '{ "CamelCase":"attribute" }' }

      context 'when response body contains array of strings' do
        let(:response) { double('response', body: raw_data, headers: nil) }

        it { is_expected.to eq(camel_case: 'attribute') }
      end
    end
  end
end
