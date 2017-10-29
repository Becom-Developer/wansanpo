# NAME

wansanpo/controller/sanpo/deposit - Wansanpo お散歩情報

# SYNOPSIS

## URL

- GET - `/sanpo/deposit/:id` - show - 預け、預かり詳細
- GET - `/sanpo/deposit/create` - create - 預け依頼を新規作成する画面
- POST - `/sanpo/deposit` - store - 預け依頼新規登録実行
- GET - `/sanpo/deposit/:id/edit` - edit - 預け依頼を編集する画面
- POST - `/sanpo/deposit/:id/update` - update - 預け依頼を更新実行
- GET - `/sanpo/deposit/search` - search - 預け、預かり情報検索画面
- GET - `/sanpo/deposit/list` - list - 自分がお散歩した記録の一覧
- POST - `/sanpo/deposit/:id/remove` - remove - 預け、預かり情報削除

# DESCRIPTION

## GET - `/sanpo/deposit/:id` - show - お散歩詳細

```
お散歩記録の詳細
お散歩したペットへのリンク
お散歩したペットの飼い主へのリンク
お散歩情報検索へのリンク
アプリメニューへリンク
```

## GET - `/sanpo/deposit/create` - create - 預け依頼を新規作成する画面

```
```

## POST - `/sanpo/deposit` - store - 預け依頼新規登録実行

```
```

## GET - `/sanpo/deposit/:id/edit` - edit - 預け依頼を編集する画面

```
```

## POST - `/sanpo/deposit/:id/update` - update - 預け依頼を更新実行

```
```

## GET - `/sanpo/deposit/search` - search - お散歩情報検索画面

```
現在お散歩可能なペット情報一覧を表示
アプリメニューへリンク
```

## GET - `/sanpo/deposit/list` - list - 自分がお散歩した記録の一覧

```
自分がお散歩記録の終了したもの、お散歩中のものを日付の新しい順に表示
ペットの名前、お散歩開始日、終了日
お散歩記録の詳細へのリンク
```

## POST - `/sanpo/deposit/:id/remove` - remove - 預け、預かり情報削除

```
```

# TODO

# SEE ALSO

- `lib/Wansanpo/Controller/Sanpo/Deposit.pm` -
- `lib/Wansanpo/Model/Sanpo/Deposit.pm` -
- `templates/sanpo/deposit/welcome.html.ep` -
- `t/wansanpo/controller/sanpo/deposit.t` -

