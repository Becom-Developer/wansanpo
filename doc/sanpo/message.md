# NAME

sanpo/message - wansanpo メッセージ

# SYNOPSIS

## URL

- GET - `/sanpo/message/:id` - show - メッセージ詳細
- GET - `/sanpo/message/create/:id` - create - メッセージを新規作成する画面
- POST - `/sanpo/message` - store - メッセージ新規登録実行
- GET - `/sanpo/message/:id/edit` - edit - メッセージを編集する画面
- POST - `/sanpo/message/:id/update` - update - メッセージを更新実行
- GET - `/sanpo/message/search` - search - メッセージ情報検索画面
- GET - `/sanpo/message/list/:id` - list - メッセージ情報ユーザー個別に一覧表示
- POST - `/sanpo/message/:id/remove` - remove - メッセージ情報削除

## GET - `/sanpo/message/:id` - show - メッセージ詳細

```
```

## GET - `/sanpo/message/create/:id` - create - メッセージを新規作成する画面

```
ユーザー情報詳細のメッセージを送るボタンをクリックすると遷移する
ユーザー情報詳細から遷移の場合は id のパラメーターをつける
`list` 画面の新規作成ボタンをクリックすると遷移する
`list` から遷移の場合は id のパラメーターをつける
送り先を選択するセレクトには送り先が自動でセットされる
```

## POST - `/sanpo/message` - store - メッセージ新規登録実行

```
```

## GET - `/sanpo/message/:id/edit` - edit - メッセージを編集する画面

```
```

## POST - `/sanpo/message/:id/update` - update - メッセージを更新実行

```
```

## GET - `/sanpo/message/search` - search - メッセージ情報検索画面

```
ログインしているユーザーとメッセージ履歴のあるユーザーを一覧表示
表示はメッセージの更新が新しい順番に上から並べる
```

## GET - `/sanpo/message/list/:id` - list - メッセージ情報ユーザー個別に一覧表示

```
ログインしているユーザーとメッセージ履歴があるユーザーとのやりとりを一覧表示
表示はメッセージの更新が新しい順番に上から並べる
相手のメッセージは左側、自分のメッセージは右側表示
メッセージ新規作成のボタン
```

## POST - `/sanpo/message/:id/remove` - remove - メッセージ情報削除

```
```


# SEE ALSO

