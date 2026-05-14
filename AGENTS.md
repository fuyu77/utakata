# AIコーディングエージェント向けのガイドライン

AIコーディングエージェント向けのガイドラインを記載します。

## 動作環境

ローカル環境でDockerとGitHub CLIが動作することを前提としています。

## 使用言語

ユーザーへの回答や、各種アウトプットに、日本語を使用します。

## コマンドリスト

- Install: `docker compose run --rm app bundle install`
- Migrate: `docker compose run --rm app bin/rails db:migrate`
- Lint: `docker compose run --rm app bin/rubocop`

## Git運用

- `feature/` から始めるブランチ名とします
- コミット前に差分を確認し、複数の関心が混在している場合は、変更単位ごとに別々にコミットします
- コミットメッセージは、変更内容と目的が第三者に伝わるように記載します

## GitHub PR作成

GitHubのPR作成を指示された場合は、以下の方針でPRを作成します。

- Open状態で作成します
- タイトルは開発対象のIssueと同じとします
- PRの説明を変更内容と目的が第三者に伝わるように記載します
- `Resolves` の記法を用いて開発対象のIssueと紐づけます
- assigneeに実装者を指定します
