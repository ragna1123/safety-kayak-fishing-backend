FactoryBot.define do
  factory :tide_data do
    association :location
    time { Time.current }
    tide_type { ['high', 'low'].sample } # 'high' または 'low' のどちらかをランダムに選択
    height { rand(0.0..3.0) } # 0.0 から 3.0 の範囲でランダムな値を生成
  end
end
