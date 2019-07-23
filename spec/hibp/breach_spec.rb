# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hibp::Breach do
  describe '.new' do
    subject { described_class.new(attributes) }

    context 'when attributes are valid' do
      let(:attributes) do
        {
          name: 'name',
          title: 'title',
          domain: 'domain',
          description: 'description',
          logo_path: 'logo',
          data_classes: %w[wat so],
          pwn_count: 1,
          breach_date: '2019-07-22',
          added_date: '2019-07-22',
          modified_date: '2019-07-22',
          is_verified: true,
          is_fabricated: true,
          is_sensitive: true,
          is_retired: true,
          is_spam_list: true
        }
      end

      it { expect(subject.name).to eq('name') }

      it { expect(subject.title).to eq('title') }

      it { expect(subject.domain).to eq('domain') }

      it { expect(subject.description).to eq('description') }

      it { expect(subject.logo_path).to eq('logo') }

      it { expect(subject.data_classes).to eq(%w[wat so]) }

      it { expect(subject.pwn_count).to eq(1) }

      it { expect(subject.breach_date).to eq('2019-07-22') }

      it { expect(subject.added_date).to eq('2019-07-22') }

      it { expect(subject.modified_date).to eq('2019-07-22') }

      it { expect(subject.is_verified).to eq(true) }

      it { expect(subject.is_fabricated).to eq(true) }

      it { expect(subject.is_sensitive).to eq(true) }

      it { expect(subject.is_retired).to eq(true) }

      it { expect(subject.is_spam_list).to eq(true) }
    end

    context 'when attributes are not valid' do
      let(:attributes) { %w[wat so] }

      it { expect { subject }.to raise_error(ArgumentError) }
    end
  end

  describe '#verified?' do
    subject { described_class.new(is_verified: true).verified? }

    it { is_expected.to be(true) }
  end

  describe '#fabricated?' do
    subject { described_class.new(is_fabricated: true).fabricated? }

    it { is_expected.to be(true) }
  end

  describe '#sensitive?' do
    subject { described_class.new(is_sensitive: true).sensitive? }

    it { is_expected.to be(true) }
  end

  describe '#retired?' do
    subject { described_class.new(is_retired: true).retired? }

    it { is_expected.to be(true) }
  end

  describe '#spam_list?' do
    subject { described_class.new(is_spam_list: true).spam_list? }

    it { is_expected.to be(true) }
  end
end
