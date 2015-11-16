require 'spec_helper'

RSpec.describe Scrapinghub::Client do
  let(:client) { Scrapinghub::Client.new('SAMPLE_API_KEY') }

  describe '#initialize' do
    it 'returns Scrapinghub::Client instance with api key set' do
      expect(client).to be_kind_of Scrapinghub::Client
      expect(client.api_key).to eq 'SAMPLE_API_KEY'
    end
  end

  describe '#jobs' do
    subject { client.jobs }
    it { is_expected.to be_kind_of Scrapinghub::Jobs }
  end

  describe '#items' do
    subject { client.items }
    it { is_expected.to be_kind_of Scrapinghub::Items }
  end

  describe '#logs' do
    subject { client.logs }
    it { is_expected.to be_kind_of Scrapinghub::Logs }
  end
end
