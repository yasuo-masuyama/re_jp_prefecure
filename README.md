# JpPrefecture

`re_jp_prefecture` は、本家 [`jp_prefecture`](https://github.com/chocoby/jp_prefecture) 互換の API を意識した再実装の Ruby gem です。日本の都道府県コードと都道府県名の変換、ActiveRecord モデルとの連携を提供します。

JIS X 0401 で定義されている都道府県コードをベースに、ゼロから始まるものはゼロを削除して使用しています。

```
北海道: 01 -> 1
東京都: 13 -> 13
```

都道府県コードと都道府県名のマッピングは変更することもできます。詳しくは「都道府県のマッピング情報を変更する」の項目を参照してください。

また、Rails のプラグインとして使用することもできます。

## 使い方

### ライブラリの読み込み

```ruby
require "jp_prefecture"
```

### 都道府県コードから都道府県を検索

都道府県コードを渡すと、都道府県コードから都道府県を検索します:

```ruby
pref = JpPrefecture::Prefecture.find(13)
# => #<JpPrefecture::Prefecture:0x... @code=13, @name="東京都", @name_e="tokyo", @name_r="tōkyō", @name_h="とうきょうと", @name_k="トウキョウト", @area="関東", @type="都", @zips=[1000000..2080035]>
pref.code
# => 13
pref.name
# => "東京都"
pref.name_e
# => "tokyo"
pref.name_r
# => "tōkyō"
pref.name_h
# => "とうきょうと"
pref.name_k
# => "トウキョウト"
pref.area
# => "関東"
pref.type
# => "都"
```

以下のように書くことも可能です:

```ruby
JpPrefecture::Prefecture.find(code: 13)
```

### 都道府県を検索

前方一致で都道府県を検索します:

```ruby
# 漢字表記
JpPrefecture::Prefecture.find(name: "東京都")
JpPrefecture::Prefecture.find(name: "東京")

# 英語表記
JpPrefecture::Prefecture.find(name_e: "tokyo")
JpPrefecture::Prefecture.find(name_e: "Tokyo")

# ローマ字表記
JpPrefecture::Prefecture.find(name_r: "tōkyō")
JpPrefecture::Prefecture.find(name_r: "Tōkyō")

# ひらがな表記
JpPrefecture::Prefecture.find(name_h: "とうきょうと")

# カタカナ表記
JpPrefecture::Prefecture.find(name_k: "トウキョウト")
```

マッピングのすべての項目を検索します (推奨しません):

```ruby
JpPrefecture::Prefecture.find(all_fields: "東京")
```

### 都道府県の一覧を取得

```ruby
JpPrefecture::Prefecture.all
# => [#<JpPrefecture::Prefecture:0x... @code=1, @name="北海道", @name_e="hokkaido", @name_r="hokkaidō", @name_h="ほっかいどう", @name_k="ホッカイドウ", @area="北海道", @type="道", @zips=[10000..70895, 400000..996509]>, ...]
```

### Rails (ActiveRecord) で使用する

`ActiveRecord::Base` を継承した Model で、都道府県コードを扱うことができます。

app/models/place.rb:

```ruby
# prefecture_code:integer
class Place < ActiveRecord::Base
  include JpPrefecture

  jp_prefecture :prefecture_code
end
```

`prefecture` というメソッドが生成され、都道府県コード、都道府県名が参照できるようになります:

```ruby
place = Place.new
place.prefecture_code = 13
place.prefecture.name
# => "東京都"
```

生成されるメソッド名は `method_name` というオプションで指定することができます:

```ruby
# model
jp_prefecture :prefecture_code, method_name: :pref

place = Place.new
place.prefecture_code = 13
place.pref.name
# => "東京都"
```

### テンプレートで使用する

`collection_select` を使用して、都道府県のセレクトボックスを生成することができます:

```ruby
f.collection_select :prefecture_code, JpPrefecture::Prefecture.all, :code, :name

# 英語表記で出力
f.collection_select :prefecture_code, JpPrefecture::Prefecture.all, :code, :name_e
```

### 都道府県のマッピング情報を変更する

デフォルトのマッピング情報以外のものを使用したい場合、以下のようにカスタマイズされたマッピングデータを指定することができます:

```ruby
custom_mapping_path = "/path/to/mapping_data.yml"

JpPrefecture.setup do |config|
  config.mapping_data = YAML.load_file(custom_mapping_path)
end
```

マッピングデータのフォーマットについては [prefecture.yml](https://github.com/yasuo-masuyama/re_jp_prefecure/blob/master/data/prefecture.yml) を参考にしてください。

### 郵便番号の情報を変更する

```ruby
custom_zip_mapping_path = "/path/to/zip_mapping_data.yml"

JpPrefecture.setup do |config|
  config.zip_mapping_data = YAML.load_file(custom_zip_mapping_path)
end
```

データのフォーマットについては [zip_code.yml](https://github.com/yasuo-masuyama/re_jp_prefecure/blob/master/data/zip_code.yml) を参考にしてください。

## インストール

RubyGems には未公開です。以下の行を `Gemfile` に記述してから:

```ruby
gem "re_jp_prefecture", git: "https://github.com/yasuo-masuyama/re_jp_prefecure"
```

`bundle` を実行してください。
