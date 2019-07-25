# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hibp::Parsers::Breach do
  describe '#parse_response' do
    subject { described_class.new.parse_response(response) }

    let(:response) { double('response', body: data, headers: {}) }

    context 'when data is a single object' do
      let!(:data) do
        {
          'Name' => 'name',
          'Title' => 'title',
          'Domain' => 'domain',
          'BreachDate' => '2013-10-04',
          'AddedDate' => '2013-12-04T00:00:00Z',
          'ModifiedDate' => '2013-12-04T00:00:00Z',
          'PwnCount' => 1,
          'Description' => 'description',
          'DataClasses' => %w[wat so],
          'LogoPath' => 'logo'
        }.to_json
      end

      it { is_expected.to be_an(Hibp::Models::Breach) }

      it { expect(subject.name).to eq('name') }

      it { expect(subject.domain).to eq('domain') }

      it { expect(subject.title).to eq('title') }

      it { expect(subject.breach_date).to eq(Date.parse('2013-10-04')) }

      it { expect(subject.added_date).to eq(Time.parse('2013-12-04T00:00:00Z')) }

      it { expect(subject.modified_date).to eq(Time.parse('2013-12-04T00:00:00Z')) }

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
        ].to_json
      end

      it { is_expected.to be_an(Array) }

      it { expect(subject.size).to be(2) }

      it { expect(subject.all? { |e| e.is_a?(Hibp::Models::Breach) }).to be(true) }
    end
  end
end
