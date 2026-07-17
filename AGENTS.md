# 開発ガイドライン

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
- 独立して理解・検証できる変更単位でコミットします
- コミットメッセージは、変更の意図と影響が簡潔に伝わるように記載します

## GitHub PR作成

GitHubのPR作成を指示された場合は、以下の方針でPRを作成します。

- Open状態で作成します
- タイトルは開発対象のIssueと同じとします
- PRの説明は、レビュアーが変更の意図と影響を理解できるよう、必要な情報を簡潔に記載します
- `Resolves` の記法を用いて開発対象のIssueと紐づけます
- assigneeに実装者を指定します
