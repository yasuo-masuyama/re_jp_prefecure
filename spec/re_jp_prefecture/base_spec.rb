# frozen_string_literal: true

RSpec.describe JpPrefecture::Base do
  def build_model_class(column)
    Class.new do
      include JpPrefecture
      jp_prefecture column

      attr_accessor column

      define_method(:initialize) { |value| send("#{column}=", value) }
    end
  end

  let(:model_class) { build_model_class(:prefecture_code) }

  describe ".jp_prefecture" do
    it "include したクラスでマクロが利用可能になる" do
      klass = Class.new { include JpPrefecture }
      expect(klass).to respond_to(:jp_prefecture)
    end

    it "指定したカラム名から prefecture インスタンスメソッドを定義する" do
      instance = model_class.new(13)
      expect(instance).to respond_to(:prefecture)
    end

    it "prefecture メソッドが対応する Prefecture インスタンスを返す" do
      instance = model_class.new(13)
      expect(instance.prefecture).to be_a(JpPrefecture::Prefecture)
      expect(instance.prefecture.name).to eq("東京都")
    end

    it "コードが nil の場合は nil を返す" do
      expect(model_class.new(nil).prefecture).to be_nil
    end

    it "存在しないコードの場合は nil を返す" do
      expect(model_class.new(99).prefecture).to be_nil
    end

    it "カラム名は任意の名前を指定できる" do
      klass = build_model_class(:pref_id)
      expect(klass.new(27).prefecture.name).to eq("大阪府")
    end

    it "カラム名に文字列を指定しても動作する" do
      klass = build_model_class("prefecture_code")
      expect(klass.new(1).prefecture.name).to eq("北海道")
    end

    it "クラス間で prefecture メソッドが干渉しない" do
      first = model_class.new(13)
      second = build_model_class(:other_code).new(27)

      expect(first.prefecture.name).to eq("東京都")
      expect(second.prefecture.name).to eq("大阪府")
    end
  end

  describe "ActiveRecord 非依存" do
    it "send(column) に応えるだけのオブジェクトでも動作する（Struct）" do
      struct_class = Struct.new(:prefecture_code) do
        include JpPrefecture
        jp_prefecture :prefecture_code
      end

      expect(struct_class.new(13).prefecture.name).to eq("東京都")
    end
  end
end
