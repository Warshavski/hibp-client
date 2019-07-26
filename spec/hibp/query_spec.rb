# frozen_string_literal: true

RSpec.describe Hibp::Query do
  let!(:api_host) { 'https://haveibeenpwned.com/api/v3' }

  describe '#new' do
    subject do
      described_class.new(endpoint: 'wat', parser: nil, headers: { key: 'wat' })
    end

    it { expect(subject.endpoint).to eq('wat') }

    it { expect(subject.parser).to be(nil) }

    it { expect(subject.headers).to eq(key: 'wat') }
  end

  describe '#where' do
    subject { described_class.new(endpoint: 'wat').where(filters) }

    let!(:filters) do
      {
        truncate: 'truncate',
        domain: 'domain',
        unverified: 'unverified'
      }
    end

    it { is_expected.to be_an(Hibp::Query) }

    it 'converts filters params' do
      actual_filters = subject.instance_variable_get(:@query_params)

      expected_filters = {
        'domain' => 'domain',
        'includeUnverified' => 'unverified',
        'truncateResponse' => 'truncate'
      }

      expect(actual_filters).to eq(expected_filters)
    end
  end

  describe '#fetch' do
    let!(:request) { double('request', get: true) }

    before do
      allow_any_instance_of(described_class).to(
        receive(:confugure_request).and_return(request)
      )
    end

    subject { described_class.new(endpoint: 'test').fetch }

    it { expect(subject).to be true }
  end
end
