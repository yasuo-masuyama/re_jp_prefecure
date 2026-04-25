# frozen_string_literal: true

RSpec.describe JpPrefecture::Prefecture do
  before do
    JpPrefecture.instance_variable_set(:@config, nil)
    described_class.instance_variable_set(:@base_mapping_data, nil)
    described_class.instance_variable_set(:@base_zip_mapping_data, nil)
  end

  after do
    JpPrefecture.instance_variable_set(:@config, nil)
    described_class.instance_variable_set(:@base_mapping_data, nil)
    described_class.instance_variable_set(:@base_zip_mapping_data, nil)
  end

  describe ".all" do
    it "47都道府県分のインスタンスを返す" do
      expect(described_class.all.size).to eq(47)
    end

    it "全要素が Prefecture インスタンスである" do
      expect(described_class.all).to all(be_a(described_class))
    end

    it "code 1..47 を保持している" do
      expect(described_class.all.map(&:code)).to match_array((1..47).to_a)
    end

    it "code=13 が東京都である" do
      tokyo = described_class.all.find { |pref| pref.code == 13 }
      expect(tokyo.name).to eq("東京都")
      expect(tokyo.type).to eq("都")
    end
  end

  describe "属性" do
    let(:hokkaido) { described_class.build_by_code(1) }

    it "name / name_e / name_r / name_h / name_k / area / type / zips を持つ" do
      expect(hokkaido.code).to eq(1)
      expect(hokkaido.name).to eq("北海道")
      expect(hokkaido.name_e).to eq("hokkaido")
      expect(hokkaido.name_r).to eq("hokkaidō")
      expect(hokkaido.name_h).to eq("ほっかいどう")
      expect(hokkaido.name_k).to eq("ホッカイドウ")
      expect(hokkaido.area).to eq("北海道")
      expect(hokkaido.type).to eq("道")
      expect(hokkaido.zips).to be_an(Array)
    end

    it "zips の各要素が Range<Integer> である" do
      expect(hokkaido.zips).to all(be_a(Range))
      hokkaido.zips.each do |range|
        expect(range.begin).to be_an(Integer)
        expect(range.end).to be_an(Integer)
      end
    end

    it "ゼロ落ち郵便番号（060-0000 → 60000）が zips レンジに含まれる" do
      zero_loss_zip = 60_000 # 060-0000 の整数表現（先頭ゼロ落ち）
      expect(hokkaido.zips.any? { |range| range.cover?(zero_loss_zip) }).to be true
    end
  end

  describe ".build_by_code" do
    it "Integer のコードに対応するインスタンスを返す" do
      pref = described_class.build_by_code(13)
      expect(pref).to be_a(described_class)
      expect(pref.name).to eq("東京都")
    end

    it "存在しないコードに対しては nil を返す" do
      expect(described_class.build_by_code(99)).to be_nil
    end

    it "0 や負数に対しても nil を返す" do
      expect(described_class.build_by_code(0)).to be_nil
      expect(described_class.build_by_code(-1)).to be_nil
    end
  end

  describe "Config オーバーレイ" do
    let(:custom_mapping) do
      {
        1 => {
          name: "カスタム北海道",
          name_e: "custom_hokkaido",
          name_r: "custom_hokkaidō",
          name_h: "かすたむほっかいどう",
          name_k: "カスタムホッカイドウ",
          area: "カスタム",
          type: "道"
        }
      }
    end
    let(:custom_zip_mapping) { { 1 => [[1, 9]] } }

    it "Config.mapping_data が Hash の場合、その内容で上書きされる" do
      JpPrefecture.setup { |c| c.mapping_data = custom_mapping }
      pref = described_class.build_by_code(1)
      expect(pref.name).to eq("カスタム北海道")
      expect(pref.area).to eq("カスタム")
    end

    it "Config.zip_mapping_data が Hash の場合、その内容で zips が上書きされる" do
      JpPrefecture.setup { |c| c.zip_mapping_data = custom_zip_mapping }
      pref = described_class.build_by_code(1)
      expect(pref.zips).to eq([(1..9)])
    end

    it "Config.mapping_data がファイルパスの場合、YAMLとしてロードされる" do
      require "tempfile"
      Tempfile.create(["custom_prefecture", ".yml"]) do |f|
        f.write(YAML.dump(custom_mapping))
        f.flush
        JpPrefecture.setup { |c| c.mapping_data = f.path }
        pref = described_class.build_by_code(1)
        expect(pref.name).to eq("カスタム北海道")
      end
    end

    it "Config.zip_mapping_data がファイルパスの場合、YAMLとしてロードされる" do
      require "tempfile"
      Tempfile.create(["custom_zip_code", ".yml"]) do |f|
        f.write(YAML.dump(custom_zip_mapping))
        f.flush
        JpPrefecture.setup { |c| c.zip_mapping_data = f.path }
        pref = described_class.build_by_code(1)
        expect(pref.zips).to eq([(1..9)])
      end
    end

    it "setup を後から呼んでも次回アクセスから反映される" do
      first = described_class.build_by_code(1)
      expect(first.name).to eq("北海道")

      JpPrefecture.setup { |c| c.mapping_data = custom_mapping }
      second = described_class.build_by_code(1)
      expect(second.name).to eq("カスタム北海道")
    end
  end

  describe "メモ化" do
    it "デフォルトYAMLは初回のみロードされる" do
      expect(YAML).to receive(:load_file).at_most(:twice).and_call_original
      described_class.all
      described_class.all
      described_class.build_by_code(13)
    end
  end
end
