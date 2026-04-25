# frozen_string_literal: true

RSpec.describe JpPrefecture::Config do
  subject(:config) { described_class.new }

  describe "#mapping_data" do
    it "未設定の場合は nil を返す" do
      expect(config.mapping_data).to be_nil
    end

    it "値を設定して取得できる" do
      config.mapping_data = "/path/to/custom_prefecture.yml"
      expect(config.mapping_data).to eq("/path/to/custom_prefecture.yml")
    end

    it "Hash 等の任意のデータも設定できる" do
      data = { 1 => { name: "北海道" } }
      config.mapping_data = data
      expect(config.mapping_data).to eq(data)
    end
  end

  describe "#zip_mapping_data" do
    it "未設定の場合は nil を返す" do
      expect(config.zip_mapping_data).to be_nil
    end

    it "値を設定して取得できる" do
      config.zip_mapping_data = "/path/to/custom_zip_code.yml"
      expect(config.zip_mapping_data).to eq("/path/to/custom_zip_code.yml")
    end

    it "Hash 等の任意のデータも設定できる" do
      data = { 1 => [[40_000, 49_999]] }
      config.zip_mapping_data = data
      expect(config.zip_mapping_data).to eq(data)
    end
  end

  describe "属性の独立性" do
    it "mapping_data と zip_mapping_data は互いに独立している" do
      config.mapping_data = "a"
      config.zip_mapping_data = "b"
      expect(config.mapping_data).to eq("a")
      expect(config.zip_mapping_data).to eq("b")
    end
  end
end
