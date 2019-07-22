# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hibp::Breaches::Converter do
  describe '#convert' do
    subject { described_class.new.convert(data) }

    context 'when data is a single object' do
      let!(:data) do
        {
          'Name' => 'name',
          'Title' => 'title',
          'Domain' => 'domain',
          'BreachDate' => '2019-07-22',
          'AddedDate' => '2019-07-22',
          'ModifiedDate' => '2019-07-22',
          'PwnCount' => 1,
          'Description' => 'description',
          'DataClasses' => %w[wat so],
          'LogoPath' => 'logo'
        }
      end

      it { is_expected.to be_an(Hibp::Breach) }

      it { expect(subject.name).to eq('name') }

      it { expect(subject.domain).to eq('domain') }

      it { expect(subject.title).to eq('title') }

      it { expect(subject.breach_date).to eq('2019-07-22') }

      it { expect(subject.added_date).to eq('2019-07-22') }

      it { expect(subject.modified_date).to eq('2019-07-22') }

      it { expect(subject.pwn_count).to eq(1) }

      it { expect(subject.description).to eq('description') }

      it { expect(subject.data_classes).to eq(%w[wat so]) }

      it { expect(subject.logo_path).to eq('logo') }
    end

    context 'when data is an array' do
      let!(:data) do
        [
          {
            'Name' => 'name#1',
            'Title' => 'title#1',
            'Domain' => 'domain#1'
          },
          {
            'Name' => 'name#2',
            'Title' => 'title#2',
            'Domain' => 'domain#2'
          }
        ]
      end

      it { is_expected.to be_an(Array) }

      it { expect(subject.size).to be(2) }

      it { expect(subject.all? { |e| e.is_a?(Hibp::Breach) }).to be(true) }
    end
  end
end
