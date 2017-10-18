# NAME

sanpo/profile - wansanpo ユーザー情報

# SYNOPSIS

## URL

- GET - `/sanpo/profile/:id` - ユーザー情報詳細
- GET - `/sanpo/profile/:id/edit` - ユーザー情報編集画面
- GET - `/sanpo/profile/search` - ユーザー情報検索(お仲間)
- POST - `/sanpo/profile/:id/update` - ユーザー情報更新実行
- POST - `/sanpo/profile/:id/remove` - ユーザー情報削除(退会)

# DESCRIPTION

## GET - `/sanpo/profile/:id` - ユーザー情報詳細

```
ユーザー情報一式表示
ユーザーに紐づくペットのリスト表示
ペットのリストはペット詳細へのリンク
ログイン者自身の詳細は編集画面へのボタン
ログイン者以外の詳細はメッセージを送るボタン
ユーザー情報検索へのボタン
アプリメニューへのボタン
TODO
    アイコン画像の登録は詳細画面から
    更新完了後は詳細画面にもどる
    アップされた画像ファイルは重複しない名前に変更して保存
    保存場所 `public/var/icon/`
    例: `public/var/icon/20171018123044_0281.jpg`
    `public/var/` は git 管理からはずす
    サンプル画像データを `public/var` にコピーするコマンドをつくっておく
```

## GET - `/sanpo/profile/:id/edit` - ユーザー情報編集画面

```
ユーザー情報一式表示
編集実行のボタン
ユーザー情報詳細へのボタン
```

## GET - `/sanpo/profile/search` - ユーザー情報検索(お仲間)

```
登録ユーザー情報をすべて表示
各ユーザー詳細画面へのリンクボタン
各ユーザーのアイコン、住所、メール表示
自分自身のユーザーアイコンは強調する
```

## POST - `/sanpo/profile/:id/update` - ユーザー情報更新実行

```
ユーザー情報を更新
更新完了後、更新したユーザー詳細画面へ遷移
TODO
    アイコン画像の更新は別のアクションにする
```

## POST - `/sanpo/profile/:id/remove` - ユーザー情報削除(退会)

```
TODO
    ユーザー情報と紐づくデータを論理削除
    削除はユーザー本人もしくは管理権限が admin 以上のユーザー
```

# SEE ALSO
