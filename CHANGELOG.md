# Changelog

## [Unreleased]

### Changed

- `Prefecture.build_by_code` を `Prefecture.find_by_code` のエイリアスに変更し、コード検索 API を `find_by_code` に一本化（#27）
- `Base#jp_prefecture` の内部実装を `send` から `public_send` に変更（#27）
