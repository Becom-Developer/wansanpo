# NAME

deploy - web サーバー準備からソースコード更新手順

# SYNOPSIS

## サーバー契約

1. SAKURA internet vps - 申し込みから利用開始まで 1時間くらい時間がかかる場合がある
1. 完了すると「仮登録完了のお知らせ」メールが届くので大切に保管

## サーバー情報

- vps: ik1-304-12451.vs.sakura.ne.jp
- v4: 153.126.137.205
- v6: 2401:2500:102:3004:153:126:137:205

## ユーザー一覧

パスワードは別途参照

```
root
pass: ****

id: wansanpo
pass: ****

id: taniguti
pass: ****

id: hiramatsu
pass: ****

id: kusakabe
pass: ****
```

## ソースコード更新手順

1. github -> ローカル環境へ pull (最新の状態にしておく)
1. ローカル環境 -> github へ push (修正を反映)
1. github -> vpsサーバーへ pull (vpsサーバーへ反映)
1. アプリケーション再起動

```
(ローカル環境から各自のアカウントでログイン)
$ ssh taniguti@153.126.137.205

# アプリケーションユーザーに
$ sudo su - wansanpo

# 移動後、git 更新
$ cd ~/wansanpo/
$ git pull origin master

# 再起動
$ carton exec -- hypnotoad script/wansanpo
```

## アプリケーション起動方法その他

```
(モード指定しなければ hypnotoad は production で実行される)
(開始 すぐにデーモン化)
$ carton exec -- hypnotoad script/wansanpo

(開始 出力待ちの状態で開始)
$ carton exec -- hypnotoad --foreground script/wansanpo

(再起動 開始している状態でまた同じことを入力)
$ carton exec -- hypnotoad script/wansanpo

(停止)
$ carton exec -- hypnotoad --stop script/wansanpo

(起動のテストして終了 テストコードが実行されるわけではない)
$ carton exec -- hypnotoad --test script/wansanpo
```

# DESCRIPTION

## 大まかなセットアップの流れ

1. システムの基本的な設定 (インストールからユーザ作成)
1. リモートコントロールするための ssh の設定
1. デプロイの手順をまとめる
1. 各ミドルウェアアプリの設定
1. アプリケーションユーザー内にアプリ配置
1. 最低限のセキュリティ設定
1. web サーバーの準備
1. web ブラウザでの確認

## 事前に済ましておくこと

- sakura vps 契約一式
    - 申し込んで使えるまで1時間ほどかかる場合がある
- 基本的な UNIX の知識
- github 内で web サーバーで公開したい web アプリのリポジトリ作成

## SETUP

### システムの基本的な設定 (インストールからユーザ作成)

__こちらを参照する__

- [os_sakuravps](https://github.com/ykHakata/summary/blob/master/os_sakuravps.md) - sakura vps でのシステムの基本設定

### リモートコントロールするための ssh の設定

__こちらを参照する__

- [ssh_sakuravps](https://github.com/ykHakata/summary/blob/master/ssh_sakuravps.md) - ssh 設定 sakura vps と github

### デプロイの手順をまとめる

ソースコード更新手順を参照

### 各ミドルウェアアプリの設定

perl は 5.26.0 を選択

__こちらを参照する__

- [perl5_install](https://github.com/ykHakata/summary/blob/master/perl5_install.md) - perl5 ローカル環境での設定手順

### アプリケーションユーザー内にアプリ配置

__github のソースコードを配置__

```
$ cd ~/
$ pwd
/home/wansanpo
$ git clone git@github.com:ykHakata/wansanpo.git
$ cd ~/wansanpo/wansanpo/
$ pwd
/home/wansanpo/wansanpo

(carton を使い必要なモジュール一式インストール)
$ carton install

(アプリケーションスタート)
$ carton exec -- hypnotoad script/wansanpo

(停止)
$ carton exec -- hypnotoad --stop script/wansanpo
```

### 最低限のセキュリティ設定

__こちらを参照する__

- [security_sakuravps](https://github.com/ykHakata/summary/blob/master/security_sakuravps.md) - 最低限のセキュリティの設定

### web サーバーの準備

__こちらを参照する__

- [nginx_sakuravps](https://github.com/ykHakata/summary/blob/master/nginx_sakuravps.md) - sakura vps での nginx の基本設定

### web ブラウザでの確認

- <http://153.126.137.205/> - 開発用のため IP 直接入力

# SEE ALSO

## 公式サイト

- <https://www.sakura.ad.jp/> - SAKURA internet

## マニュアル

- <https://help.sakura.ad.jp/hc/ja/categories/201105252> - さくらのサポート情報 > VPS
- <https://help.sakura.ad.jp/hc/ja/articles/206208181> - 【さくらのVPS】サーバの初期設定ガイド
- <https://vps-news.sakura.ad.jp/tutorials/> - VPSチュートリアル

```
基本的にはこちらのガイドにそって初期設定を行う、この中から手順を抜粋したものを紹介
```
