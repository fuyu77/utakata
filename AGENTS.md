# AIコーディングエージェント向けのガイドライン

## コマンドの実行方法

Rails関連のタスクを実行する際は、ローカル環境で直接コマンドを叩かず、常にDocker Compose経由でコンテナ内のアプリケーションにアクセスします。

```
docker compose run --rm app <command>
```

## Lint command

```
docker compose run --rm app bin/rubocop
```

## Gitデフォルトブランチ

`master` がデフォルトブランチです。

## Gitブランチ名

`feature/` から始めるブランチ名としてください。

## コミットメッセージ

コミットメッセージは[Conventional Commits](https://www.conventionalcommits.org/ja/v1.0.0/)のスタイルに準拠します。

## GitHub PR作成

GitHubのPR作成を指示された際は、以下の方針でPRを作成します。

- タイトルは開発対象のIssueと同じにします
- PRの説明を記載します
- `Resolves` の記法を用いて開発対象のIssueと紐づけます
- assigneeに実装者を指定します

## 作業依頼のプロンプト例

### 開発依頼

```
develop issue <issue number>
```

このように依頼された場合は、以下を実行します。

- ghコマンドで指定されたissueの内容を確認します
- 開発ブランチを新しく作成します
- 開発します

### PR作成依頼

```
create pr
```

このように依頼された場合は、以下を実行します。

- ghコマンドでprを作成します

### コードレビュー依頼

```
review pr <pr number>
```

このように依頼された場合は、以下を実行します。

- ghコマンドで指定されたprの内容を確認し、コードレビューします
