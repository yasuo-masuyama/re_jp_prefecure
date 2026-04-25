# frozen_string_literal: true

RSpec.describe JpPrefecture::Base do
  let(:model_class) do
    Class.new do
      include JpPrefecture
      jp_prefecture :prefecture_code

      attr_accessor :prefecture_code

      def initialize(prefecture_code)
        @prefecture_code = prefecture_code
      end
    end
  end

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
      instance = model_class.new(nil)
      expect(instance.prefecture).to be_nil
    end

    it "存在しないコードの場合は nil を返す" do
      instance = model_class.new(99)
      expect(instance.prefecture).to be_nil
    end

    it "カラム名は任意の名前を指定できる" do
      klass = Class.new do
        include JpPrefecture
        jp_prefecture :pref_id

        attr_accessor :pref_id

        def initialize(pref_id)
          @pref_id = pref_id
        end
      end

      instance = klass.new(27)
      expect(instance.prefecture.name).to eq("大阪府")
    end

    it "カラム名に文字列を指定しても動作する" do
      klass = Class.new do
        include JpPrefecture
        jp_prefecture "prefecture_code"

        attr_accessor :prefecture_code

        def initialize(prefecture_code)
          @prefecture_code = prefecture_code
        end
      end

      expect(klass.new(1).prefecture.name).to eq("北海道")
    end

    it "クラス間で prefecture メソッドが干渉しない" do
      other_class = Class.new do
        include JpPrefecture
        jp_prefecture :other_code

        attr_accessor :other_code

        def initialize(other_code)
          @other_code = other_code
        end
      end

      first = model_class.new(13)
      second = other_class.new(27)

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
