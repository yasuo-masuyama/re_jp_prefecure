# frozen_string_literal: true

RSpec.describe JpPrefecture do
  before { JpPrefecture.instance_variable_set(:@config, nil) }
  after  { JpPrefecture.instance_variable_set(:@config, nil) }

  describe ".config" do
    it "JpPrefecture::Config のインスタンスを返す" do
      expect(JpPrefecture.config).to be_a(JpPrefecture::Config)
    end

    it "メモ化されており、複数回呼び出しても同じインスタンスを返す" do
      first = JpPrefecture.config
      second = JpPrefecture.config
      expect(first).to equal(second)
    end
  end

  describe ".setup" do
    it "ブロックに config を渡して設定値を変更できる" do
      JpPrefecture.setup do |config|
        config.mapping_data = "/path/to/custom_prefecture.yml"
        config.zip_mapping_data = "/path/to/custom_zip_code.yml"
      end

      expect(JpPrefecture.config.mapping_data).to eq("/path/to/custom_prefecture.yml")
      expect(JpPrefecture.config.zip_mapping_data).to eq("/path/to/custom_zip_code.yml")
    end

    it "setup 後も .config は同じインスタンスを返す（メモ化を破壊しない）" do
      JpPrefecture.setup { |config| config.mapping_data = "a" }
      first = JpPrefecture.config
      JpPrefecture.setup { |config| config.zip_mapping_data = "b" }
      second = JpPrefecture.config
      expect(first).to equal(second)
    end
  end

  describe "Base" do
    it "空モジュールとして定義されている" do
      expect(JpPrefecture::Base).to be_a(Module)
    end
  end

  describe "include されたとき" do
    it "include 先のクラスに Base が extend される" do
      klass = Class.new { include JpPrefecture }
      expect(klass.singleton_class.include?(JpPrefecture::Base)).to be true
    end
  end
end
