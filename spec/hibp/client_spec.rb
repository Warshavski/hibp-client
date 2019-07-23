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
      subject { described_class.new.fetch_breaches(domain: domain) }

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

  describe '#fetch_account_breaches' do
    subject { described_class.new.fetch_account_breaches(account) }

    let!(:account)  { 'wat' }
    let!(:data)     { '[{ "Name": "wat", "Title": "so" }]' }

    before do
      stub_request(:get, "#{api_host}/breachedaccount/#{account}")
        .to_return(body: data)
    end

    it { is_expected.to be_an(Array) }

    it { expect(subject.size).to be(1) }

    it { expect(subject.first).to be_an(Hibp::Breach) }

    it 'returns breach with parsed data' do
      breach = subject.first

      expect(breach.name).to eq('wat')
      expect(breach.title).to eq('so')
    end

    context 'when filters are set' do
      context 'when domain filter is set' do
        subject { described_class.new.fetch_account_breaches(account, domain: domain) }

        let!(:domain) { 'so' }

        before do
          stub_request(:get, "#{api_host}/breachedaccount/#{account}?domain=so")
            .to_return(body: data)
        end

        it 'returns an array of breached models' do
          actual_models = subject

          expect(actual_models).to be_an(Array)
          expect(actual_models.size).to be(1)
          expect(actual_models.first).to be_an(Hibp::Breach)
        end
      end

      context 'when truncate filter is set' do
        subject { described_class.new.fetch_account_breaches(account, truncate: true) }

        before do
          stub_request(:get, "#{api_host}/breachedaccount/#{account}?truncateResponse=true")
            .to_return(body: data)
        end

        it 'returns an array of breached models' do
          actual_models = subject

          expect(actual_models).to be_an(Array)
          expect(actual_models.size).to be(1)
          expect(actual_models.first).to be_an(Hibp::Breach)
        end
      end

      context 'when unverified filter is set' do
        subject { described_class.new.fetch_account_breaches(account, unverified: true) }

        before do
          stub_request(:get, "#{api_host}/breachedaccount/#{account}?includeUnverified=true")
            .to_return(body: data)
        end

        it 'returns an array of breached models' do
          actual_models = subject

          expect(actual_models).to be_an(Array)
          expect(actual_models.size).to be(1)
          expect(actual_models.first).to be_an(Hibp::Breach)
        end
      end
    end
  end
end
