# frozen_string_literal: true

require "yaml"

RSpec.describe "data files" do
  let(:data_dir) { File.expand_path("../data", __dir__) }

  describe "data/prefecture.yml" do
    let(:path) { File.join(data_dir, "prefecture.yml") }
    let(:data) { YAML.load_file(path, permitted_classes: [Symbol]) }

    it "ファイルが存在する" do
      expect(File.exist?(path)).to be true
    end

    it "47都道府県分のエントリを保持している" do
      expect(data.keys).to match_array((1..47).to_a)
    end

    it "各エントリが必須キーを持つ" do
      required_keys = %i[name name_e name_r name_h name_k area type]
      data.each do |code, entry|
        expect(entry.keys).to include(*required_keys), "code=#{code} に不足キーがある: #{required_keys - entry.keys}"
      end
    end

    it "type が 都/道/府/県 のいずれかである" do
      data.each_value do |entry|
        expect(%w[都 道 府 県]).to include(entry[:type])
      end
    end

    it "code=13 が東京都である" do
      expect(data[13][:name]).to eq("東京都")
      expect(data[13][:type]).to eq("都")
    end
  end

  describe "data/zip_code.yml" do
    let(:path) { File.join(data_dir, "zip_code.yml") }
    let(:data) { YAML.load_file(path) }

    it "ファイルが存在する" do
      expect(File.exist?(path)).to be true
    end

    it "47都道府県分のエントリを保持している" do
      expect(data.keys).to match_array((1..47).to_a)
    end

    it "値が [[from, to], ...] 形式である" do
      data.each do |code, ranges|
        expect(ranges).to be_an(Array), "code=#{code} の値が配列ではない"
        ranges.each do |range|
          expect(range).to be_an(Array)
          expect(range.size).to eq(2)
          from, to = range
          expect(from).to be_an(Integer)
          expect(to).to be_an(Integer)
          expect(from).to be <= to
        end
      end
    end
  end
end
