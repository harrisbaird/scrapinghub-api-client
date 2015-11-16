require 'spec_helper'

RSpec.describe Scrapinghub::Items do
  let(:instance) { Scrapinghub::Client.new('SAMPLE_API_KEY').logs }

  describe '#get' do
    context 'with default format', vcr: { cassette_name: 'logs/get/format_text' } do
      subject { instance.get('00000/1/1') }
      it { is_expected.to be_kind_of String }
    end

    context 'with format set to :json', vcr: { cassette_name: 'logs/get/format_json' } do
      subject { instance.get('00000/1/1', format: 'json') }
      it "returns an array of hashes" do
        expect(subject).to be_kind_of Array
        expect(subject.first).to be_kind_of Hash
      end
    end
  end
end
