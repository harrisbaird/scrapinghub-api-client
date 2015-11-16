require 'spec_helper'

RSpec.describe Scrapinghub::Jobs do
  let(:client) { Scrapinghub::Client.new('SAMPLE_API_KEY') }
  let(:instance) { client.jobs }

  describe 'Authentication failed', vcr: { cassette_name: 'jobs/auth_failed' }  do
    it do
      expect { instance.list('00000') }.to raise_error Scrapinghub::AuthFailed
    end
  end

  describe '#schedule' do
    context 'with required args', vcr: { cassette_name: 'jobs/schedule/required_args' } do
      it 'schedules a job' do
        result = instance.schedule('00000', 'test_scraper')
        expect(result).to be_kind_of Scrapinghub::Job
        expect(result.id).to eq '00000/1/8'
        expect(result.client).to eq client
      end
    end

    context 'with optional args', vcr: { cassette_name: 'jobs/schedule/optional_args' } do
      it 'schedules a job' do
        result = instance.schedule('00000', 'test_scraper', add_tag: %w(tag1 tag2))
        expect(result).to be_kind_of Scrapinghub::Job
        expect(result.id).to eq '00000/1/9'
        expect(result.client).to eq client
      end
    end

    context 'when invalid', vcr: { cassette_name: 'jobs/schedule/invalid' } do
      subject { -> { instance.schedule('invalid', '') } }
      it { is_expected.to raise_error Scrapinghub::BadRequest, 'invalid value for project: invalid' }
    end
  end

  describe '#list' do
    context 'with required args', vcr: { cassette_name: 'jobs/list/required_args' } do
      it 'returns all jobs for project' do
        result = instance.list('00000')
        expect(result).to be_kind_of Array
        expect(result.first).to be_kind_of Hash
        expect(result.size).to eq 1
      end
    end

    context 'with optional args', vcr: { cassette_name: 'jobs/list/optional_args' } do
      it 'returns finished jobs' do
        result = instance.list('00000', state: 'finished')
        expect(result).to be_kind_of Array
        expect(result.first).to be_kind_of Hash
        expect(result.size).to eq 1
      end
    end

    context 'with multiple args', vcr: { cassette_name: 'jobs/list/multiple_args' } do
      it 'returns finished jobs' do
        result = instance.list('00000', lacks_tag: ['parsed', 'scheduled'])
        expect(result).to be_kind_of Array
        expect(result.first).to be_kind_of Hash
        expect(result.size).to eq 1
      end
    end

    context 'with invalid project', vcr: { cassette_name: 'jobs/list/invalid_project' } do
      subject { -> { instance.list('invalid') } }
      it { is_expected.to raise_error Scrapinghub::BadRequest, 'invalid value for project: invalid' }
    end
  end

  describe '#update' do
    context 'with valid params', vcr: { cassette_name: 'jobs/update/valid' } do
      subject { instance.update('00000', '00000/1/9', add_tag: 'finished') }
      it { is_expected.to eq 1 }
    end

    context 'missing update modifiers', vcr: { cassette_name: 'jobs/update/missing_update_modifiers' } do
      subject { -> { instance.update('00000', '00000/1/9') } }
      it { is_expected.to raise_error Scrapinghub::BadRequest, 'No update modifiers provided' }
    end

    context 'with invalid project', vcr: { cassette_name: 'jobs/update/invalid_project' } do
      subject { -> { instance.update('invalid', '00000/1/9') } }
      it { is_expected.to raise_error Scrapinghub::BadRequest, 'invalid value for project: invalid' }
    end
  end

  describe '#delete' do
    context 'with valid params', vcr: { cassette_name: 'jobs/delete/valid' } do
      subject { instance.delete('00000', '00000/1/9') }
      it { is_expected.to eq 1 }
    end

    context 'with invalid project', vcr: { cassette_name: 'jobs/delete/invalid_project' } do
      subject { -> { instance.delete('invalid', '00000/1/9') } }
      it { is_expected.to raise_error Scrapinghub::BadRequest, 'invalid value for project: invalid' }
    end
  end

  describe '#stop' do
    context 'with valid params', vcr: { cassette_name: 'jobs/stop/valid', record: :once } do
      subject { instance.stop('00000', '00000/2/3') }
      it { is_expected.to eq 1 }
    end

    context 'with invalid project', vcr: { cassette_name: 'jobs/stop/invalid_project', record: :once } do
      subject { -> { instance.stop('invalid', '00000/1/9') } }
      it { is_expected.to raise_error Scrapinghub::BadRequest, 'invalid value for project: invalid' }
    end
  end
end
