require 'spec_helper'

RSpec.describe Scrapinghub::Items do
  let(:instance) { Scrapinghub::Items.new('SAMPLE_API_KEY') }

  describe '#get' do
    context 'with project_id', vcr: { cassette_name: 'items/get/project_id' } do
      subject { instance.get('00000').size }
      it { is_expected.to eq 10 }
    end

    context 'with spider_id', vcr: { cassette_name: 'items/get/spider_id' } do
      subject { instance.get('00000/1').size }
      it { is_expected.to eq 10 }
    end

    context 'with job_id', vcr: { cassette_name: 'items/get/job_id' } do
      subject { instance.get('00000/1/1').size }
      it { is_expected.to eq 10 }
    end

    context 'with item_no', vcr: { cassette_name: 'items/get/item_no' } do
      subject { instance.get('00000/1/1/2').size }
      it { is_expected.to eq 1 }
    end
  end

  describe '#stats' do
    context 'when valid', vcr: { cassette_name: 'items/stats/valid' } do
      subject { instance.stats('00000/1/1') }
      it { is_expected.to be_kind_of Hash }
    end
  end
end
