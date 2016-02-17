require 'rails_helper'

describe ImageUploader do

  describe '#store_dir' do
  end

  describe '#extension_white_list' do
    it 'returns the correct list' do
      expect(ImageUploader.new.extension_white_list).to eq(%w(jpg jpeg gif png))
    end
  end

end