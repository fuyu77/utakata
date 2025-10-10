# AGENTS

## 開発環境ポリシー

Rails関連のタスクを実行する際は、ローカル環境で直接コマンドを叩かず、常に Docker Compose 経由でコンテナ内のアプリケーションにアクセスします。

```
docker compose run --rm app <command>
```

## Lint command

docker compose run --rm app bin/rubocop

## コミットポリシー

コミットメッセージは [Conventional Commits](https://www.conventionalcommits.org/ja/v1.0.0/) に準拠させ、履歴から変更意図が追跡できるようにします。
