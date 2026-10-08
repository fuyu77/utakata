# Utakata for iOS

Hotwire Nativeを利用した検証用iOSアプリです。画面の内容はRailsアプリが配信し、iOS側が画面遷移を管理します。

## 起動方法

1. Railsアプリを`http://localhost:3000`で起動します。
2. Xcodeで`Utakata.xcodeproj`を開きます。
3. `Utakata`スキームと任意のiPhone Simulatorを選び、実行します。

Debugビルドは`http://localhost:3000`、Releaseビルドは`https://utakatanka.jp`に接続します。XcodeのScheme設定で`UTAKATA_ROOT_URL`環境変数を指定すると、接続先を上書きできます。

画面遷移ルールは`public/configurations/ios_v1.json`で一元管理しています。同じファイルをアプリの初期設定として同梱し、起動後にRailsが配信する`/configurations/ios_v1.json`で更新します。

起動時に認証状態を確認し、未ログインの場合はログイン画面を表示します。認証後は短歌、検索、通知、マイページの4つのタブへ切り替わります。各タブは独立したNavigation Stackを持ちますが、ログアウト時にはすべて破棄されます。

短歌タブの直下には「人気」「新着」「フォロー中」のフィードタブを表示します。フィード間の移動には既存のRails側のURLを使用し、短歌詳細などフィード以外の画面ではフィードタブを非表示にします。
