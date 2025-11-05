# AIコーディングエージェント向けのガイドライン

AIコーディングエージェント向けのガイドラインを記載します。ローカル環境でDockerとGitHub CLIが動作することを前提としています。

## ローカル環境でのコマンド実行方法

ローカル環境でコマンドを実行する場合は、直接コマンドを実行せず、常にDocker Compose経由でコンテナ内のアプリケーションにアクセスします。

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
- PRの説明を記載します
- `Resolves` の記法を用いて開発対象のIssueと紐づけます
- assigneeに実装者を指定します

## 作業依頼のプロンプト

### Issueの開発

```text
develop issue <ISSUE_NUMBER>
```

このように依頼された場合は、以下を実行します。

- ghコマンドで指定された<ISSUE_NUMBER>のissueの内容を確認します
- 開発用のGitブランチを新しく作成します
- 開発します

#### オプション指定

- --wt git worktreeで作業ディレクトリを作成します

### PR作成

```text
create pr
```

このように依頼された場合は、以下を実行します。

- ghコマンドでprを作成します

### コードレビュー

```text
review pr <PR_NUMBER>
```

このように依頼された場合は、以下を実行します。

- ghコマンドで<PR_NUMBER>のprのコードレビューをします
