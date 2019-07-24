# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hibp::Models::Password do
  describe '.new' do
    subject { described_class.new(attributes) }

    # source, :id, :title, :date, :email_count
    context 'when attributes are valid' do
      let(:attributes) do
        {
          suffix: '023C5510E0EA91FEA8620EBD7055EEC96AD',
          occurrences: 1
        }
      end

      it { expect(subject.suffix).to eq('023C5510E0EA91FEA8620EBD7055EEC96AD') }

      it { expect(subject.occurrences).to be(1) }
    end

    context 'when attributes are not valid' do
      let(:attributes) { %w[wat so] }

      it { expect { subject }.to raise_error(ArgumentError) }
    end
  end
end
