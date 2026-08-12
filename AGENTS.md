# 開発ガイドライン

## コマンドリスト

- Install: `docker compose run --rm app bundle install`
- Migrate: `docker compose run --rm app bin/rails db:migrate`
- Lint: `docker compose run --rm app bin/rubocop`

## 使用言語

ユーザーへの回答や、各種アウトプットに、日本語を使用します。

## Git運用

- `feature/` から始めるブランチ名とします
- 変更を独立してレビュー可能な単位に分け、1つの単位を実装・確認したら、その時点でコミットしてから次の変更に進みます
- 独立した変更を未コミットのまま並行して進めたり、最後にまとめて1つのコミットにしたりしません
- コミットメッセージは、変更内容と理由が分かるように記載します

## GitHub PR作成

GitHubのPR作成を指示された場合は、以下の方針でPRを作成します。

- Open状態で作成します
- タイトルは開発対象のIssueと同じとします
- `Resolves` の記法を用いて開発対象のIssueと紐づけます
- assigneeに実装者を指定します
