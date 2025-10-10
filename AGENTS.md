# AGENTS

このドキュメントは、エージェントや自動化ツールが本リポジトリと安全かつ一貫性を保って連携するための共通ルールをまとめたものです。

## 開発環境ポリシー

- Rails関連のタスクを実行する際は、ローカル環境で直接コマンドを叩かず、常に Docker Compose 経由でコンテナ内のアプリケーションにアクセスします。
- 基本形: `docker compose run --rm app <rails command>`
  - 例: Rails コンソールを開く場合は `docker compose run --rm app bin/rails console`

## 品質チェック

- Lint: `docker compose run --rm app bin/rubocop`
  - 実行前に不要なコンテナが残っていないか確認し、最新の依存関係に合わせて実行してください。

## コミットポリシー

- コミットメッセージは [Conventional Commits](https://www.conventionalcommits.org/ja/v1.0.0/) に準拠させ、履歴から変更意図が追跡できるようにします。
- 例: `feat: add health check endpoint`
