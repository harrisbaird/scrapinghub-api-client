require 'spec_helper'

RSpec.describe Scrapinghub::Jobs do
  let(:instance) { Scrapinghub::Jobs.new('SAMPLE_API_KEY') }

  describe '#schedule' do
    context 'with required args', vcr: { cassette_name: 'jobs/schedule/required_args' } do
      it 'schedules a job' do
        result = instance.schedule('00000', 'test_scraper')
        expect(result).to eq '00000/1/8'
      end
    end

    context 'with optional args', vcr: { cassette_name: 'jobs/schedule/optional_args' } do
      it 'schedules a job' do
        result = instance.schedule('00000', 'test_scraper', add_tag: %w(tag1 tag2))
        expect(result).to eq '00000/1/9'
      end
    end

    context 'with multiple spiders', vcr: { cassette_name: 'jobs/schedule/multiple' } do
      it 'schedules a job but only returns a single job id' do
        result = instance.schedule('00000', %w(test_scraper test_scraper_2), add_tag: %w(tag1 tag2))
        expect(result).to eq '00000/2/3'
      end
    end

    context 'when invalid', vcr: { cassette_name: 'jobs/schedule/invalid' } do
      it 'raises a Scrapinghub::BadRequest exception' do
        expect { instance.schedule('invalid', '') }.to raise_error Scrapinghub::BadRequest,
                                                                   'invalid value for project: invalid'
      end
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

    context 'when invalid', vcr: { cassette_name: 'jobs/list/invalid' } do
      it 'raises a Scrapinghub::BadRequest exception' do
        expect { instance.list('invalid') }.to raise_error Scrapinghub::BadRequest,
                                                           'invalid value for project: invalid'
      end
    end
  end
end
