# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

日本の都道府県を正規表現で扱うRuby gem（`re_jp_prefecture`）の再作成。

## ビルド・テスト・リント

- 全体検証: `bundle exec rake`（RSpec + RuboCop を実行）
- テストのみ: `bundle exec rspec`
- 単一テスト: `bundle exec rspec spec/ファイル名_spec.rb:行番号`
- リント: `bundle exec rubocop`
- リント自動修正: `bundle exec rubocop -A`
- セットアップ: `bin/setup`
- コンソール: `bin/console`

## コードスタイル

- 文字列リテラル: ダブルクォート強制（`Style/StringLiterals`）
- 行の最大長: 120文字
- ターゲットRubyバージョン: 3.1.4

## テスト方針

- TDD（テスト駆動開発）: テストを先に書き、テストが通るようにコードを実装する
- RSpec使用、`spec/` ディレクトリ配下に配置

## Git規約

- ブランチ命名: `dev/番号_説明`（例: `dev/2_ai_environment_setup`）
- コミットメッセージ: プレフィックス付き（例: `feat:`, `fix:`, `chore:`, `docs:`, `test:`, `refactor:`）
- PRテンプレート: `.github/pull_request_template.md`（日本語）

## コミュニケーション

- 選択肢がある場合はトレードオフを説明してから実装する
