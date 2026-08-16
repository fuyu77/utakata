# Utakata for iOS

Hotwire Nativeを利用した検証用iOSアプリです。画面の内容はRailsアプリが配信し、iOS側が画面遷移を管理します。

## 起動方法

1. Railsアプリを`http://localhost:3000`で起動します。
2. Xcodeで`Utakata.xcodeproj`を開きます。
3. `Utakata`スキームと任意のiPhone Simulatorを選び、実行します。

Debugビルドは`http://localhost:3000`、Releaseビルドは`https://utakatanka.jp`に接続します。XcodeのScheme設定で`UTAKATA_ROOT_URL`環境変数を指定すると、接続先を上書きできます。

画面遷移ルールは`public/configurations/ios_v1.json`で一元管理しています。同じファイルをアプリの初期設定として同梱し、起動後にRailsが配信する`/configurations/ios_v1.json`で更新します。

トップレベルには短歌、検索、通知、マイページの4つのタブがあります。各タブは独立したNavigation Stackを持つため、タブを切り替えてもそれぞれの画面履歴が維持されます。タブを選択すると現在の画面を再読み込みし、ログインやログアウト後の認証状態を反映します。未ログインで認証が必要なタブを開いた場合は、ログイン画面へ遷移します。
