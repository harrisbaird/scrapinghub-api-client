require 'spec_helper'

RSpec.describe Scrapinghub::Job do
  let(:client) { Scrapinghub::Client.new('SAMPLE_API_KEY') }
  let(:job) { Scrapinghub::Job.new(client, '00000/1/1') }

  describe '#items' do
    it 'calls Scrapinghub::Items#get' do
      expect(client.items).to receive(:get).with('00000/1/1')
      job.items
    end
  end

  describe '#logs' do
    it 'calls Scrapinghub::Logs#get' do
      expect(client.logs).to receive(:get).with('00000/1/1', {})
      job.logs
    end

    it 'calls Scrapinghub::Items#get with optional kwargs' do
      expect(client.logs).to receive(:get).with('00000/1/1', format: 'json')
      job.logs(format: 'json')
    end
  end

  describe '#state' do
    context 'when running', vcr: { cassette_name: 'job/state_running' } do
      subject { job.state }
      it { is_expected.to eq 'running' }
    end

    context 'when finished', vcr: { cassette_name: 'job/state_finished' } do
      subject { job.state }
      it { is_expected.to eq 'finished' }
    end
  end

  describe '#finished?' do
    context 'when running', vcr: { cassette_name: 'job/state_running' } do
      subject { job.finished? }
      it { is_expected.to be false }
    end

    context 'when finished', vcr: { cassette_name: 'job/state_finished' } do
      subject { job.finished? }
      it { is_expected.to be true }
    end
  end
end
