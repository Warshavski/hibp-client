# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hibp::Paste do
  describe '.new' do
    subject { described_class.new(attributes) }

    # source, :id, :title, :date, :email_count
    context 'when attributes are valid' do
      let(:attributes) do
        {
          source: 'source',
          id: 'identity',
          title: 'title',
          date: 'date',
          email_count: 'email count'
        }
      end

      it { expect(subject.source).to eq('source') }

      it { expect(subject.id).to eq('identity') }

      it { expect(subject.title).to eq('title') }

      it { expect(subject.date).to eq('date') }

      it { expect(subject.email_count).to eq('email count') }
    end

    context 'when attributes are not valid' do
      let(:attributes) { %w[wat so] }

      it { expect { subject }.to raise_error(ArgumentError) }
    end
  end
end
