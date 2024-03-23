require 'rails_helper'

RSpec.describe TideData, type: :model do
  describe 'バリデーション' do
    it '有効であること' do
      tide_data = build(:tide_data) # Factory Botを使用してtide_dataインスタンスを作成
      expect(tide_data).to be_valid
    end

    it 'timeが必要であること' do
      tide_data = build(:tide_data, time: nil)
      expect(tide_data).not_to be_valid
    end

    it 'typeが必要であること' do
      tide_data = build(:tide_data, tide_type: nil)
      expect(tide_data).not_to be_valid
    end

    it 'heightが必要であること' do
      tide_data = build(:tide_data, height: nil)
      expect(tide_data).not_to be_valid
    end
  end
end
