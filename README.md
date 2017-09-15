# NAME

wansanpo - 犬のお散歩マッチングサービス

# SYNOPSIS

## URL

<http://nyans.work/> - 開発用サーバー

## LOCAL SETUP

お手元の開発環境設定

### INSTALL

環境構築、準備

#### git clone

お手元の PC に任意のディレクトリを準備後、 github サイトよりリポジトリを取得

<https://github.com/ykHakata/wansanpo> - wansanpo / github サイト

```
(例: ホームディレクト配下に github 用のディレクトリ作成)
$ mkdir ~/github

# github ディレクトリ配下に wansanpo リポジトリ展開
$ cd ~/github
$ git clone git@github.com:ykHakata/wansanpo.git
```

#### Perl install

```bash
# 5.26.0 を使用
$ cd ~/github/wansanpo/
$ cat .perl-version
5.26.0
```

plenv を活用し、perl 5.26.0, cpnam, carton までのインストールを実行

手順の参考

<https://github.com/ykHakata/summary/blob/master/perl5_install.md> - perl5_install / perl5 ローカル環境での設定手順

#### Mojolicious install

Mojolicious を始めとする必要なモジュール一式のインストール実行

```
(cpanfile に必要なモジュール情報が記載)
$ cd ~/github/wansanpo/
$ cat cpanfile
requires 'Mojolicious', '== 7.45';

(carton を使いインストール実行)
$ carton install
```

## START APP

アプリケーションスタート

### お手元の PC

```
(WEBフレームワークを起動 development モード)
$ carton exec -- morbo script/wansanpo

(終了時は control + c で終了)
```

コマンドラインで morbo サーバー実行後、web ブラウザ `http://localhost:3000/` で確認

### 開発サーバー

web サーバー nginx 通常はつねに稼働中、サーバーの起動は root 権限

```
(サーバースタート)
# nginx

(サーバーを停止)
# nginx -s quit
```

app サーバー hypnotoad

```
(production モード)
$ carton exec -- hypnotoad script/wansanpo

(停止)
$ carton exec -- hypnotoad --stop script/wansanpo
```

web ブラウザ <http://nyans.work/> で確認

## TEST

テストコードを実行

```
(テストコードを起動の際は mode を切り替え)
$ carton exec -- script/wansanpo test --mode testing

(テスト結果を詳細に出力)
$ carton exec -- script/wansanpo test -v --mode testing

(テスト結果を詳細かつ個別に出力)
$ carton exec -- script/wansanpo test -v --mode testing t/wansanpo.t

(自動で testing になるように設定している)
$ carton exec -- script/wansanpo test -v t/wansanpo.t
```

## DEPLOY

1. github -> ローカル環境へ pull (最新の状態にしておく)
1. ローカル環境 -> github へ push (修正を反映)
1. github -> vpsサーバーへ pull (vpsサーバーへ反映)
1. アプリケーション再起動

```
(ローカル環境から各自のアカウントでログイン)
$ ssh taniguti@153.126.137.205

(アプリケーションユーザーに)
$ sudo su - wansanpo

(移動後、git 更新)
$ cd ~/wansanpo/
$ git pull origin master

(再起動)
$ carton exec -- hypnotoad script/wansanpo
```

# DESCRIPTION

# TODO

## 開発の進め方基本ルール

### サイクル

```
常にURLにアクセスして回覧できる状態にしておく
実際に使用して検証する
必要な機能を少しづつ追加する
見直し、修正
```

### 仕様設計

```
完結な仕様を示す資料を残す
仕様書の資料は重複した存在を避ける
仕様の変更が行われた場合は仕様書の変更を必ず行う
```

### 実装方法

```
言語や言語の拡張ライブラリでまかなえる機能はオリジナルの実装を避けて活用する
拡張ライブラリを活用する場合は必要最低限してできるだけ依存度を低くする
自動テストコードと同時進行で実装コードをコーディングする
仕様は常に変更されることを前提にして、コードの結合を低く小さい単位で実装
```

### 動作検証

```
自動テストコードで担保できる部分は担保する
自動テストコードは全てを完全に再現できないことを前提にしておく
最終は本番の環境で実際に動作確認をする
```

### 納期

```
厳守
```

## 開発進行の目安

### 公開された領域の開発

- 開発用のサーバー選定
- 最低限のサーバーの初期設定
- 暫定のURLを設定
- URLでアクセス確認
- 告知サイト暫定実装
- 告知サイトからのユーザー登録画面
- ユーザー登録のロジック
    - フォームからEメールを入力
    - 登録メルアドに返信メールがくる
    - メールに初期パスワードが記載されている
    - 初期パスワードをつかってログイン入力
    - ログイン入力完了をもってしてユーザー登録完了
- ログイン画面
- ログイン認証のロジック

### 認証で保護された領域の開発

__`/doc/sanpo/` を参照__

- ログイン完了時の画面
- ユーザー情報編集画面
- ペット情報編集画面
- 預けの依頼を作成する画面
- 預け、預かり情報検索画面
- 預け、預かり情報詳細画面
- メッセージ画面

## DB 初期設計

いづれ作り直すことになるので、最低限度にとどめておく

命名規則参考

- <http://qiita.com/softark/items/63e68a0172a1d2f92b5c>
- <http://oxynotes.com/?p=8679>

何かの動作が完了したことを表現するには、過去分詞を使う

__`/db/wansanpo_schema.sql/` を参照__

# EXAMPLES

# SEE ALSO
