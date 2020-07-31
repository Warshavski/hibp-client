# frozen_string_literal: true

RSpec.describe Hibp::Parsers::Password do
  describe '#parse_response' do
    subject { described_class.new.parse_response(response) }

    context 'when converter not set' do
      let(:response) { double('response', body: body, headers: nil) }

      let(:body) do
        "0018A45C4D1DEF81644B54AB7F969B88D65:1\r\n00D4F6E8FA6EECAD2A3AA415EEC418D38EC:2"
      end

      it { expect(subject).to be_an(Array) }

      it { expect(subject.size).to be(2) }

      it 'returns array of parsed passwords models' do
        actual_passwords = subject

        suffixes = actual_passwords.map(&:suffix)
        occurrences = actual_passwords.map(&:occurrences)

        expect(suffixes).to eq(%w[0018A45C4D1DEF81644B54AB7F969B88D65 00D4F6E8FA6EECAD2A3AA415EEC418D38EC])
        expect(occurrences).to eq([1, 2])
      end

      context 'when there are passwords with 0 occurrences' do
        let(:body) do
          "0018A45C41DEF81644B54AB7F969B88D65:1\r\n00D4F6E8FA6EECAD2A3AA415EEC418D38EC:2\r\n003D68EB55068C33ACE09247EE4C639306B:0"
        end

        it 'does not convert them into password models' do
          actual_passwords = subject

          suffixes = actual_passwords.map(&:suffix)

          expect(actual_passwords.count).to eq(2)
          expect(suffixes).not_to include('003D68EB55068C33ACE09247EE4C639306B')
        end
      end
    end
  end
end
