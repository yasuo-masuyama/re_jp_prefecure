# frozen_string_literal: true

RSpec.describe JpPrefecture::Searchable do
  let(:record_struct) do
    Struct.new(:code, :name, :name_e, :name_r, :name_h, :name_k, :zips, keyword_init: true)
  end

  let(:records) do
    [
      record_struct.new(code: 1, name: "北海道", name_e: "hokkaido", name_r: "hokkaidō",
                        name_h: "ほっかいどう", name_k: "ホッカイドウ",
                        zips: [10_000..70_895, 400_000..996_509]),
      record_struct.new(code: 13, name: "東京都", name_e: "tokyo", name_r: "tōkyō",
                        name_h: "とうきょうと", name_k: "トウキョウト",
                        zips: [1_000_001..2_088_504]),
      record_struct.new(code: 27, name: "大阪府", name_e: "osaka", name_r: "ōsaka",
                        name_h: "おおさかふ", name_k: "オオサカフ",
                        zips: [5_300_001..5_999_999])
    ]
  end

  let(:dummy_class) do
    target = records
    Class.new do
      extend JpPrefecture::Searchable
      define_singleton_method(:all) { target }
    end
  end

  describe ".find_by_code" do
    it "完全一致でインスタンスを返す" do
      result = dummy_class.find_by_code(13)
      expect(result.name).to eq("東京都")
    end

    it "該当なしの場合は nil を返す" do
      expect(dummy_class.find_by_code(99)).to be_nil
    end

    it "nil 入力に対しては nil を返す" do
      expect(dummy_class.find_by_code(nil)).to be_nil
    end
  end

  describe ".find_by_name" do
    it "前方一致でインスタンスを返す" do
      expect(dummy_class.find_by_name("東京").name).to eq("東京都")
    end

    it "完全一致でも返す" do
      expect(dummy_class.find_by_name("北海道").name).to eq("北海道")
    end

    it "部分一致（前方ではない）はマッチしない" do
      expect(dummy_class.find_by_name("京都")).to be_nil
    end

    it "該当なしの場合は nil を返す" do
      expect(dummy_class.find_by_name("沖縄")).to be_nil
    end

    it "nil / 空文字入力に対しては nil を返す" do
      expect(dummy_class.find_by_name(nil)).to be_nil
      expect(dummy_class.find_by_name("")).to be_nil
    end
  end

  describe ".find_by_name_e" do
    it "前方一致・大文字小文字無視で返す" do
      expect(dummy_class.find_by_name_e("TOK").name).to eq("東京都")
      expect(dummy_class.find_by_name_e("hok").name).to eq("北海道")
    end

    it "該当なしの場合は nil を返す" do
      expect(dummy_class.find_by_name_e("xyz")).to be_nil
    end
  end

  describe ".find_by_name_r" do
    it "前方一致・大文字小文字無視で返す" do
      expect(dummy_class.find_by_name_r("Tō").name).to eq("東京都")
    end

    it "該当なしの場合は nil を返す" do
      expect(dummy_class.find_by_name_r("xyz")).to be_nil
    end
  end

  describe ".find_by_name_h" do
    it "前方一致で返す" do
      expect(dummy_class.find_by_name_h("とうきょう").name).to eq("東京都")
    end

    it "該当なしの場合は nil を返す" do
      expect(dummy_class.find_by_name_h("ふくおか")).to be_nil
    end
  end

  describe ".find_by_name_k" do
    it "前方一致で返す" do
      expect(dummy_class.find_by_name_k("トウキョウ").name).to eq("東京都")
    end

    it "該当なしの場合は nil を返す" do
      expect(dummy_class.find_by_name_k("フクオカ")).to be_nil
    end
  end

  describe ".find_by_zip" do
    it "zips レンジに含まれる郵便番号で逆引きする" do
      expect(dummy_class.find_by_zip(1_500_000).name).to eq("東京都")
    end

    it "レンジ範囲外は nil を返す" do
      expect(dummy_class.find_by_zip(99_999_999)).to be_nil
    end

    it "ゼロ落ち郵便番号でも一致する" do
      expect(dummy_class.find_by_zip(60_000).name).to eq("北海道")
    end

    it "レンジの begin 値ちょうどに一致する" do
      expect(dummy_class.find_by_zip(1_000_001).name).to eq("東京都")
    end

    it "レンジの end 値ちょうどに一致する" do
      expect(dummy_class.find_by_zip(2_088_504).name).to eq("東京都")
    end

    it "複数 zip レンジの2番目にヒットするケースを返す" do
      # 北海道は 10_000..70_895 と 400_000..996_509 の2レンジを持つ
      expect(dummy_class.find_by_zip(500_000).name).to eq("北海道")
    end

    it "レンジ間の隙間値は nil を返す" do
      # 北海道の 70_895 と 400_000 の間
      expect(dummy_class.find_by_zip(70_896)).to be_nil
    end

    it "nil 入力に対しては nil を返す" do
      expect(dummy_class.find_by_zip(nil)).to be_nil
    end
  end

  describe "Template Method 契約" do
    it "extend 先の .all を呼び出して検索する" do
      expect(dummy_class).to receive(:all).and_call_original
      dummy_class.find_by_code(1)
    end

    it "Searchable は .all を提供しない" do
      expect(JpPrefecture::Searchable.instance_methods).not_to include(:all)
      expect(JpPrefecture::Searchable.singleton_methods).not_to include(:all)
    end
  end
end
