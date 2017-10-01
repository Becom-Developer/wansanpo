# NAME

sanpo/pet - wansanpo ペット情報

# SYNOPSIS

## URL

- GET - `/sanpo/pet/:id` - show - ペット情報詳細
- GET - `/sanpo/pet/:id/edit` - edit - ペット情報編集画面
- GET - `/sanpo/pet/create` - create - ペット情報新規登録画面
- POST - `/sanpo/pet` - store - ペット情報新規登録実行
- GET - `/sanpo/pet/search` - search - ペット情報検索
- POST - `/sanpo/pet/:id/update` - update - ペット情報更新実行
- POST - `/sanpo/pet/:id/remove` - remove - ペット情報削除

## GET - `/sanpo/pet/:id` - show - ペット情報詳細

```
ペット情報一式表示
ペットに紐づくユーザー情報の表示
ユーザー情報へのボタン
編集画面へのボタン
ペット情報検索へのボタン
アプリメニューへのボタン
```

## GET - `/sanpo/pet/:id/edit` - edit - ペット情報編集画面

```
```

## GET - `/sanpo/pet/create` - create - ペット情報新規登録画面

```
ユーザー情報の詳細から遷移
ペット情報の入力フォーム
登録実行ボタン
ユーザー詳細画面へ戻るボタン
アプリメニューボタン
TODO
    簡易的なバリデート
    アイコン画像の登録は別アクション
```

## POST - `/sanpo/pet` - store - ペット情報新規登録実行

```
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
```

## POST - `/sanpo/pet/:id/remove` - remove - ペット情報削除

```
```

# SEE ALSO
