# frozen_string_literal: true

module ReJpPrefecture
  # カスタムデータの差し替え用設定値を保持するクラス。
  #
  # mapping_data には都道府県データ、zip_mapping_data には郵便番号データの
  # パス または データそのものを設定できる。値が未設定の場合は nil を返す。
  class Config
    attr_accessor :mapping_data, :zip_mapping_data
  end
end
