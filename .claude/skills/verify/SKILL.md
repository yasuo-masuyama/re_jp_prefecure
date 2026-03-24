---
name: verify
description: RSpec テストと RuboCop リントを実行してコードベース全体を検証する。実装完了時やPR作成前に使用。
---

以下の手順でコードベースを検証してください:

1. `bundle exec rake` を実行（RSpec + RuboCop）
2. 失敗があれば原因を分析し、修正案を提示
3. 全てパスするまで修正とテストを繰り返す
