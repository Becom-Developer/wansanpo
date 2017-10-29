# NAME

wansanpo/controller/sanpo/pet - Wansanpo ペット情報

# SYNOPSIS

## URL

- GET - `/sanpo/pet/:id` - show - ペット情報詳細
- GET - `/sanpo/pet/:id/edit` - edit - ペット情報編集画面
- GET - `/sanpo/pet/create` - create - ペット情報新規登録画面
- POST - `/sanpo/pet` - store - ペット情報新規登録実行
- GET - `/sanpo/pet/search` - search - ペット情報検索
- POST - `/sanpo/pet/:id/update` - update - ペット情報更新実行
- POST - `/sanpo/pet/:id/remove` - remove - ペット情報削除

# DESCRIPTION

## GET - `/sanpo/pet/:id` - show - ペット情報詳細

```
ペット情報一式表示
ペットに紐づくユーザー情報の表示
ユーザー情報へのボタン
編集画面へのボタン
ペット情報検索へのボタン
アプリメニューへのボタン
アイコン画像の登録機能
変更はログイン者のペットのみ
更新完了後は詳細画面にもどる
アップされた画像ファイルは重複しない名前に変更して保存
保存場所 `public/var/icon/`
例: `public/var/icon/20171018123044_0281.jpg`
`public/var/` は git 管理からはずす
サンプル画像データを `public/var` にコピーするコマンド generate_upload_sample
```

## GET - `/sanpo/pet/:id/edit` - edit - ペット情報編集画面

```
ペット情報一式表示
編集実行のボタン
ペット情報詳細へのボタン
簡易的なバリデート
```

## GET - `/sanpo/pet/create` - create - ペット情報新規登録画面

```
ユーザー情報の詳細から遷移
ペット情報の入力フォーム
登録実行ボタン
ユーザー詳細画面へ戻るボタン
アプリメニューボタン
簡易的なバリデート
TODO
    アイコン画像の登録は別アクション
```

## POST - `/sanpo/pet` - store - ペット情報新規登録実行

```
ペット情報を新規登録
登録完了後、登録したペット詳細画面へ遷移
TODO
    アイコン画像の更新は別のアクションにする
```

## GET - `/sanpo/pet/search` - search - ペット情報検索

```
登録ペット情報をすべて表示
各ペット詳細画面へのリンクボタン
各ペットのアイコン、飼い主住所、飼い主メール表示
自分自身が飼い主のペットアイコンは強調する
```

## POST - `/sanpo/pet/:id/update` - update - ペット情報更新実行

```
ペット情報を更新
更新完了後、更新したペット詳細画面へ遷移
TODO
    アイコン画像の更新は別のアクションにする
    ```

## POST - `/sanpo/pet/:id/remove` - remove - ペット情報削除

```
```

# TODO

# SEE ALSO

- `lib/Wansanpo/Controller/Sanpo/Pet.pm` -
- `lib/Wansanpo/Model/Sanpo/Pet.pm` -
- `t/wansanpo/controller/sanpo/pet.t` -
