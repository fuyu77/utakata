# AIコーディングエージェント向けのガイドライン

## コマンドの実行方法

Rails関連のタスクを実行する際は、ローカル環境で直接コマンドを叩かず、常に Docker Compose 経由でコンテナ内のアプリケーションにアクセスします。

```
docker compose run --rm app <command>
```

## Lint command

```
docker compose run --rm app bin/rubocop
```

## コミットメッセージ

コミットメッセージは [Conventional Commits](https://www.conventionalcommits.org/ja/v1.0.0/) に準拠させ、履歴から変更意図が追跡できるようにします。

## GitHub PR作成

GitHubのPR作成を指示された際は、以下の方針でPRを作成します。

- タイトルは開発対象のIssueと同じにします
- PRの説明を記載します
- `Resolves` の記法を用いて開発対象のIssueと紐づけます
- assigneeに実装者を指定します
