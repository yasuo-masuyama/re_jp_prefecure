---
name: commit-and-pr
description: >-
  git add, commit, PR作成を一括実行する。「コミットしてPRを作って」
  「変更をプッシュしてPRを出して」「実装完了したのでPRを作成して」で使用。
  実行前にテストとリントが通っていることを確認する。
---

# コミット・PR作成

変更のコミットからPR作成までを一括で実行する。

## 実行前チェック

必ずテストとリントを先に実行し、全てパスしていることを確認する。

```bash
bundle exec rake
```

失敗がある場合はコミットしない。修正してから再実行する。

## 手順

### 1. 変更内容の確認

```bash
git status
git diff
```

### 2. ステージング

```bash
git add -A
```

ただし `.env` や秘匿情報を含むファイルは除外する。

### 3. コミット

ブランチ名からコンテキストを読み取り、適切なプレフィックスを選択する。

**プレフィックス規則**:

| プレフィックス | 用途 |
|-------------|------|
| `feat:` | 新機能追加 |
| `fix:` | バグ修正 |
| `chore:` | 設定変更・依存更新・雑務 |
| `docs:` | ドキュメント変更 |
| `test:` | テストのみの変更 |
| `refactor:` | 機能変更を伴わないリファクタリング |

```bash
git commit -m "feat: 都道府県名の正規表現マッチング機能を追加"
```

コミットメッセージは日本語で変更内容を端的に記述する。

### 4. プッシュ

```bash
git push origin HEAD
```

### 5. PR作成

`.github/pull_request_template.md` を読み取り、各セクションを変更内容に合わせて埋めてPRを作成する。

```bash
gh pr create \
  --title "<プレフィックス>: <変更内容の要約>" \
  --body "<pull_request_template.mdの各セクションを埋めた内容>" \
  --base master
```

## ブランチ命名規則

ブランチ名は `dev/番号_説明` の形式。

- 正: `dev/3_custom_skills`
- 正: `dev/4_prefecture_matching`
- 誤: `feature/prefecture`, `fix-bug`

命名が規則に沿っていない場合は作業前に指摘する。

## Common Mistakes

- **テスト未通過でコミット**: `bundle exec rake` が通るまでコミットしない
- **プレフィックス漏れ**: コミットメッセージは必ずプレフィックスから始める
- **PRテンプレート無視**: 3セクション（概要・確認方法・影響範囲）を必ず埋める
- **master直push**: 必ずブランチからPRを出す
