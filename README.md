# 短歌投稿サイト Utakata

## 概要

短歌を投稿・共有できるサイトです。[アカウント登録](https://utakatanka.jp/users/sign_up)して使ってみてください。

Issues や PR の投稿も歓迎します。

## 開発環境構築手順

```sh
docker-compose build
docker-compose run --rm app bin/setup
docker-compose up
```

## 技術スタック

- Heroku
- PostgreSQL 13
- Node.js 16
- Ruby 3
- Rails 7
- Hotwire
  - Turbo
  - Stimulus
- Bootstrap 5
- Webpacker
