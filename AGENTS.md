# AIコーディングエージェント向けのガイドライン

AIコーディングエージェント向けのガイドラインを記載します。ローカル環境でDockerとGitHub CLIが動作することを前提としています。

## ユーザーへの回答に用いる言語

ユーザーへの回答は日本語で行います。

## コマンドリスト

- Install: `docker compose run --rm app bundle install`
- Migrate: `docker compose run --rm app bin/rails db:migrate`
- Lint: `docker compose run --rm app bin/rubocop`

## Git運用

- `feature/` から始めるブランチ名とします
- コミットメッセージはConventional Commitsのスタイルとします
- コミットは無理に1つにまとめようとせずに、変更の趣旨が分かりやすいように作成します

## GitHub PR作成

GitHubのPR作成を指示された場合は、以下の方針でPRを作成します。

- タイトルは開発対象のIssueと同じとします
- PRの説明を日本語で記載します
- `Resolves` の記法を用いて開発対象のIssueと紐づけます
- assigneeに実装者を指定します

## 作業依頼のプロンプト

コマンドのようなプロンプトで、このファイルの以下に定義する一連の作業を簡単に依頼できるようにします。

以下のように、シェルコマンドのように実行できることを期待しています。

```text
# #123のIssueを開発する
develop issue 123

# #123のIssueを開発してPRを作成する
develop issue 123 && create pr
```

### develop issue <ISSUE_NUMBER>

- ghコマンドで指定された<ISSUE_NUMBER>のissueの内容を確認します
- 開発用のGitブランチを新しく作成します
- 開発します

### create pr

- ghコマンドでprを作成します

### review pr <PR_NUMBER>

- ghコマンドで<PR_NUMBER>のprのコードレビューをします
