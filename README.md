# 短歌投稿サイト Utakata

## 概要

短歌を投稿・共有できるサイトです。[アカウント登録](https://utakatanka.jp/users/sign_up)して使ってみてください。

Issues や PR の投稿も歓迎します。

## 開発環境構築手順

```sh
docker compose run --rm app bin/setup
docker compose up
```

## 確認用URL

### アプリケーション

<http://localhost:3000>

### メール

<http://localhost:3000/letter_opener>

## 技術スタック

- Heroku-22
- PostgreSQL 14
- Node.js 20
- Ruby 3
  - YJIT
- Rails 7
- Hotwire
  - Turbo
  - Stimulus
- Bootstrap 5
- Webpack 5
