# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hibp::Parsers::Paste do
  describe '#convert' do
    subject { described_class.new.parse_response(response) }

    let!(:response) { double('response', body: data, headers: {}) }

    let!(:data) do
      [{
        'Source' => 'Pastebin',
        'Title' => 'syslog',
        'Id' => '8Q0BvKD8',
        'Date' => '2014-03-04T19:14:54Z',
        'EmailCount' => '139'
      }].to_json
    end

    it { is_expected.to be_an(Array) }

    it { expect(subject.all? { |e| e.is_a?(Hibp::Models::Paste) }).to be(true) }

    it { expect(subject.first.source).to eq('Pastebin') }

    it { expect(subject.first.title).to eq('syslog') }

    it { expect(subject.first.id).to eq('8Q0BvKD8') }

    it { expect(subject.first.date).to eq('2014-03-04T19:14:54Z') }

    it { expect(subject.first.email_count).to eq('139') }
  end
end
