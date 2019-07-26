# frozen_string_literal: true

RSpec.describe Hibp::Client do
  describe '#new' do
    subject { described_class.new('api-key') }

    it { expect(subject.authorization_header).to eq('hibp-api-key' => 'api-key') }
  end

  describe '#breaches' do
    subject { described_class.new.breaches }

    it { is_expected.to be_an(Hibp::Query) }

    it { expect(subject.endpoint).to eq('https://haveibeenpwned.com/api/v3/breaches') }

    it { expect(subject.headers).to eq('hibp-api-key' => '') }
  end

  describe '#breach' do
    subject { described_class.new.breach('test') }

    it { is_expected.to be_an(Hibp::Query) }

    it { expect(subject.endpoint).to eq('https://haveibeenpwned.com/api/v3/breach/test') }

    it { expect(subject.headers).to eq('hibp-api-key' => '') }
  end

  describe '#account_breaches' do
    subject { described_class.new.account_breaches('test@example.com') }

    it { is_expected.to be_an(Hibp::Query) }

    it { expect(subject.endpoint).to eq('https://haveibeenpwned.com/api/v3/breachedaccount/test%40example.com') }

    it { expect(subject.headers).to eq('hibp-api-key' => '') }
  end

  describe '#data_classes' do
    subject { described_class.new.data_classes }

    it { is_expected.to be_an(Hibp::Query) }

    it { expect(subject.endpoint).to eq('https://haveibeenpwned.com/api/v3/dataclasses') }

    it { expect(subject.headers).to eq('hibp-api-key' => '') }
  end

  describe '#pastes' do
    subject { described_class.new.pastes('test@example.com') }

    it { is_expected.to be_an(Hibp::Query) }

    it { expect(subject.endpoint).to eq('https://haveibeenpwned.com/api/v3/pasteaccount/test%40example.com') }

    it { expect(subject.headers).to eq('hibp-api-key' => '') }
  end

  describe '#passwords' do
    subject { described_class.new.passwords('test') }

    it { is_expected.to be_an(Hibp::Query) }

    it { expect(subject.endpoint).to eq('https://api.pwnedpasswords.com/range/A94A8') }

    it { expect(subject.headers).to eq({}) }
  end
end
