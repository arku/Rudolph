require 'rails_helper'

describe ApplicationHelper do

  describe '#is_url?' do
    context 'is URL' do
      it 'returns true' do
        expect(is_url?('http://www.google.com')).to be true
        expect(is_url?('https://www.google.com')).to be true
        expect(is_url?('http://itsrudolph.com')).to be true
      end
    end

    context 'is not URL' do
      it 'returns false' do
        expect(is_url?('Flora Saramago')).to be false
        expect(is_url?('flora.saramago@gmail.com')).to be false
      end
    end
  end

  describe '#cut_text' do
    context 'cut size is smaller than text size' do
      it 'returns the cut text' do
        expect(cut_text('Flora Saramago', 3)).to eq('Flo...')
      end
    end

    context 'cut size is bigger than text size' do
      it 'returns the full text' do
        expect(cut_text('Flora Saramago', 100)).to eq('Flora Saramago')
      end
    end
  end

  describe '#localize_datetime' do
    let(:group) { Group.find(1) }

    context 'english' do
      before(:all) do
        I18n.locale = :en
      end

      it 'returns the time in AM/PM format' do
        expect(localize_datetime(group.date)).to eq('12/20/2015 08 PM')
      end
    end

    context 'portuguese' do
      before(:all) do
        I18n.locale = 'pt-br'
      end

      after(:all) do
        I18n.locale = :en
      end

      it 'returns the time in 24h format' do
        expect(localize_datetime(group.date)).to eq('20/12/2015 20:00')
      end
    end
  end

  describe '#localize_time' do
    let(:group) { Group.find(1) }

    context 'english' do
      before(:all) do
        I18n.locale = :en
      end

      it 'returns the time in AM/PM format' do
        expect(localize_time(group.date)).to eq('8 PM')
      end
    end

    context 'portuguese' do
      before(:all) do
        I18n.locale = 'pt-br'
      end

      after(:all) do
        I18n.locale = :en
      end

      it 'returns the time in 24h format' do
        expect(localize_time(group.date)).to eq('20:00')
      end
    end
  end
end