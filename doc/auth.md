# NAME

/auth - wansanpo アプリ認証

# SYNOPSIS

## URL

- GET - `/auth/entry` - create - ユーザー登録画面
- POST - `/auth/entry` - store - ユーザー登録実行
- GET - `/auth/login` - login - ログイン画面
- POST - `/auth/login` - check - ログイン実行
- POST - `/auth/logout` - logout - ログアウト実行
- GET - `/auth/:id/edit` - edit - パスワード変更画面
- POST - `/auth/:id/update` - update - パスワード変更実行

# DESCRIPTION

## GET - `/auth/entry` - create - ユーザー登録画面

```
入力フォーム
    ID(Eメール), password 入力登録
    登録済みの ID は登録不可
TODO
    バリデートルールを明確にする
```

## POST - `/auth/entry` - store - ユーザー登録実行

```
登録失敗
    ユーザー登録画面へ遷移、失敗メッセージ出力
登録成功
    ユーザー登録画面へ遷移、成功メッセージ出力
データベース
    userテーブル
    承認フラグは承認済みにする
    権限は customer
TODO
    登録確認メールを送信
    送信メールにユニークなURLを記載、リンクアクセスによる承認
```

## GET - `/auth/login` - login - ログイン画面

```
入力フォーム
    ID(Eメール), password 入力
ログイン中はログイン画面を表示しない
TODO
    バリデートルールを明確にする
    パスワード忘れの人のためのメールにパスワード送る機能
```

## POST - `/auth/login` - check - ログイン実行

```
ログイン失敗
    失敗メッセージ出力後、ログイン画面へ遷移
ログイン成功
    成功メッセージ出力後、アプリメニュー画面へ遷移
    はじめてのログイン時はプロフィール登録画面へ遷移
ログイン中はログイン実行できない
TODO
```

## POST - `/auth/logout` - logout - ログアウト実行

```
ログアウト実行ボタン
    ログイン時のみ出現、ログインボタンがログアウトボタンになる
ログアウト成功
    成功メッセージ出力後、アプリ紹介画面へ遷移
TODO
```

## POST - `/auth/:id/edit` - edit - パスワード変更画面

```
TODO
    変更画面実装
    変更画面にはログイン中でログインしている人の情報だけ表示
    変更するには現在のパスワードの入力を求める
```

## GET - `/auth/:id/update` - update - パスワード変更実行

```
TODO
    空文字やスペース、タブ文字だけなどありえない文字は登録不可
    ログイン中の自分自身のパスワードしか更新できない
```

# SEE ALSO
