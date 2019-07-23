# frozen_string_literal: true

RSpec.describe Hibp::Client do
  let!(:api_host) { 'https://haveibeenpwned.com/api/v3' }

  describe '#find_breach' do
    subject { described_class.new.find_breach(name) }

    let!(:name) { 'wat' }
    let!(:data) { '{ "Name": "wat", "Title": "so" }' }

    before do
      stub_request(:get, "#{api_host}/breach/wat").to_return(body: data)
    end

    it { is_expected.to be_an(Hibp::Breach) }

    it 'returns breach with parsed data' do
      breach = subject

      expect(breach.name).to eq('wat')
      expect(breach.title).to eq('so')
    end
  end

  describe '#fetch_breaches' do
    subject { described_class.new.fetch_breaches }

    let!(:data) { '[{ "Name": "wat", "Title": "so" }]' }

    before do
      stub_request(:get, "#{api_host}/breaches").to_return(body: data)
    end

    it { is_expected.to be_an(Array) }

    it { expect(subject.size).to be(1) }

    it { expect(subject.first).to be_an(Hibp::Breach) }

    it 'returns breach with parsed data' do
      breach = subject.first

      expect(breach.name).to eq('wat')
      expect(breach.title).to eq('so')
    end

    context 'when filter is set' do
      subject { described_class.new.fetch_breaches(domain) }

      let!(:domain) { 'wat' }

      before do
        stub_request(:get, "#{api_host}/breaches?domain=wat").to_return(body: data)
      end

      it { is_expected.to be_an(Array) }

      it { expect(subject.size).to be(1) }

      it { expect(subject.first).to be_an(Hibp::Breach) }
    end
  end

  describe '#fetch_data_classes' do
    subject { described_class.new.fetch_data_classes }

    let!(:data) { '["wat", "so", "hey"]' }

    before do
      stub_request(:get, "#{api_host}/dataclasses").to_return(body: data)
    end

    it { expect(subject).to eq(%w[wat so hey]) }
  end
end
