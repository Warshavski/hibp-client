# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hibp::Pastes::Converter do
  describe '#convert' do
    subject { described_class.new.convert(data) }

    let!(:data) do
      [{
        'Source' => 'Pastebin',
        'Title' => 'syslog',
        'Id' => '8Q0BvKD8',
        'Date' => '2014-03-04T19:14:54Z',
        'EmailCount' => '139'
      }]
    end

    it { is_expected.to be_an(Array) }

    it { expect(subject.all? { |e| e.is_a?(Hibp::Paste) }).to be(true) }

    it { expect(subject.first.source).to eq('Pastebin') }

    it { expect(subject.first.title).to eq('syslog') }

    it { expect(subject.first.id).to eq('8Q0BvKD8') }

    it { expect(subject.first.date).to eq('2014-03-04T19:14:54Z') }

    it { expect(subject.first.email_count).to eq('139') }
  end
end
