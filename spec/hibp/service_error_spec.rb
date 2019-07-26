# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Hibp::ServiceError do
  describe '.new' do
    context 'empty params' do
      subject { described_class.new }

      it { expect(subject.message).to eq(' @body=nil, @raw_body=nil, @status_code=nil') }

      it { expect(subject.body).to be_nil }

      it { expect(subject.raw_body).to be_nil }


      it { expect(subject.status_code).to be_nil }
    end

    context 'only message' do
      subject { described_class.new('test message') }

      it { expect(subject.message).to eq('test message @body=nil, @raw_body=nil, @status_code=nil') }

      it { expect(subject.body).to be_nil }

      it { expect(subject.raw_body).to be_nil }

      it { expect(subject.status_code).to be_nil }
    end

    context 'message and params' do
      subject { described_class.new('test message', params) }

      let(:params) do
        {
          body: 'body',
          raw_body: 'raw_body',
          status_code: 'status_code'
        }
      end

      it 'composes message from all params' do
        exp_message = 'test message @body="body", @raw_body="raw_body", @status_code="status_code"'

        expect(subject.message).to eq(exp_message)
      end

      it { expect(subject.body).to eq('body') }

      it { expect(subject.raw_body).to eq('raw_body') }

      it { expect(subject.status_code).to eq('status_code') }
    end
  end

  describe '#to_s' do
    subject { described_class.new(message, params).to_s }

    let(:message) { 'test message' }

    let(:params) do
      {
        body: 'body',
        raw_body: 'raw_body',
        status_code: 'status_code'
      }
    end

    it { expect(subject).to eq('test message @body="body", @raw_body="raw_body", @status_code="status_code"') }
  end
end
