# frozen_string_literal: true

RSpec.describe Hibp::Parsers::Json do
  describe '#parse_response' do
    subject { described_class.new(converter).parse_response(response) }

    context 'when converter not set' do
      let!(:converter) { nil }

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

    context 'when converter is set' do
      let!(:converter) { double('converter') }

      let(:raw_data)    { '["wat", "so", "hey"]' }
      let(:parsed_data) { %w[wat so hey] }

      before do
        allow(converter).to receive(:convert).with(parsed_data).and_return('parsed!')
      end

      context 'when response body contains array of strings' do
        let(:response) { double('response', body: raw_data, headers: nil) }

        it { is_expected.to eq('parsed!') }
      end
    end
  end
end
