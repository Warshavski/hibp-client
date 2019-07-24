# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hibp::ServiceError do
  describe '.new' do
    context 'empty params' do
      subject { described_class.new }

      it { expect(subject.message).to eq(' @data=nil, @raw_body=nil, @status_code=nil') }

      it { expect(subject.data).to be_nil }

      it { expect(subject.raw_body).to be_nil }

      it { expect(subject.status_code).to be_nil }
    end

    context 'only message' do
      subject { described_class.new('test message') }

      it { expect(subject.message).to eq('test message @data=nil, @raw_body=nil, @status_code=nil') }

      it { expect(subject.data).to be_nil }

      it { expect(subject.raw_body).to be_nil }

      it { expect(subject.status_code).to be_nil }
    end

    context 'message and params' do
      subject { described_class.new('test message', params) }

      let(:params) do
        {
          data: 'data',
          raw_body: 'raw_body',
          status_code: 'status_code'
        }
      end

      it { expect(subject.message).to eq('test message @data="data", @raw_body="raw_body", @status_code="status_code"') }

      it { expect(subject.data).to eq('data') }

      it { expect(subject.raw_body).to eq('raw_body') }

      it { expect(subject.status_code).to eq('status_code') }
    end
  end

  describe '#to_s' do
    subject { described_class.new(message, params).to_s }

    let(:message) { 'test message' }

    let(:params) do
      {
        data: 'data',
        raw_body: 'raw_body',
        status_code: 'status_code'
      }
    end

    it { expect(subject).to eq('test message @data="data", @raw_body="raw_body", @status_code="status_code"') }
  end
end
