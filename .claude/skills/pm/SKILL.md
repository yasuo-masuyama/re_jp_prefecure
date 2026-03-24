---
name: pm
description: >-
  タスク見積もり・進捗管理・GitHub Issue管理を行う。
  「今週のタスクを整理して」「このIssueの見積もりをして」「PRの状況を確認して」
  「進捗をまとめて」「定期的に状況を確認して」などで使用する。
---

# PM スキル

タスク管理・見積もり支援・GitHub連携を担う。

## ツール規約

### GitHub（`gh` コマンド）

```bash
# PR一覧・詳細
gh pr list
gh pr view <PR番号>
gh pr diff <PR番号>

# Issue一覧・詳細
gh issue list
gh issue view <Issue番号>

# API直接呼び出し
gh api repos/{owner}/{repo}/issues
gh api repos/{owner}/{repo}/pulls
```

## 見積もり方針

タスクの見積もりは以下の観点で行う:

1. **スコープ確認**: 変更ファイル数・テスト追加数・RBS更新の有無
2. **複雑度評価**: 正規表現設計の難易度・依存関係の有無
3. **ストーリーポイント目安**:
   - 1pt: メソッド1つ追加（spec + RBS含む、1-3ファイル）
   - 2pt: 機能単位の実装（複数メソッド + データ定義、3-4ファイル）
   - 3pt: クラス・モジュール設計を伴う変更（正規表現設計 + API設計、要設計判断）

## 定期バッチ実行（スケジュール機能）

Claude Codeのスケジュール機能で定期実行する場合のフロー:

1. `gh issue list` でオープンなIssueを確認
2. `gh pr list` でレビュー待ちPRを確認
3. 状況をサマリーとして出力
4. 対応が必要な項目をリストアップ

## When to Apply

- Issueの見積もり・優先度設定
- PR・Issueの状況確認
- 定期バッチによる進捗サマリー生成
- タスク分解・次のアクション整理
