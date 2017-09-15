package Wansanpo;
use Mojo::Base 'Mojolicious';
use Data::Dumper;

sub startup {
    my $self = shift;

    my $mode    = $self->mode;
    my $moniker = $self->moniker;
    my $home    = $self->home;
    my $common  = $home->child( 'etc', "$moniker.common.conf" )->to_string;
    my $conf    = $home->child( 'etc', "$moniker.$mode.conf" )->to_string;

    # 設定ファイル (読み込む順番に注意)
    $self->plugin( Config => +{ file => $common } );
    $self->plugin( Config => +{ file => $conf } );
    my $config = $self->config;

    # Documentation browser under "/perldoc"
    $self->plugin('PODRenderer') if $config->{perldoc};

    # Router
    my $r = $self->routes;

    # 告知サイト
    $r->get('/')->to('Info#index');
    $r->get('/info')->to('Info#index');
    $r->get('/info/intro')->to('Info#intro');

    # 認証関連
    $r->get('/auth/entry')->to('Auth#entry');
    $r->post('/auth/entry')->to('Auth#store_entry');
    $r->get('/auth/login')->to('Auth#login');
    $r->post('/auth/login')->to('Auth#store_login');
    $r->post('/auth/logout')->to('Auth#logout');

    # 認証保護されたページ
    # アプリメニュー
    $r->get('/sanpo/menu')->to('Sanpo#menu');

    # ユーザー情報
    $r->get('/sanpo/profile/:id')->to('Sanpo::Profile#show');
    $r->get('/sanpo/profile/:id/edit')->to('Sanpo::Profile#edit');
    $r->get('/sanpo/profile/search')->to('Sanpo::Profile#search');
    $r->post('/sanpo/profile/:id/update')->to('Sanpo::Profile#update');
    $r->post('/sanpo/profile/:id/remove')->to('Sanpo::Profile#remove');

    # ペット情報

    # - GET - `/sanpo/pet/:id` - ペット情報詳細
    # - GET - `/sanpo/pet/:id/edit` - ペット情報編集画面
    # - GET - `/sanpo/pet/create` - ペット情報新規登録画面
    # - POST - `/sanpo/pet` - ペット情報新規登録実行
    # - GET - `/sanpo/pet/search` - ペット情報検索
    # - POST - `/sanpo/pet/:id/update` - ペット情報更新実行
    # - POST - `/sanpo/pet/:id/remove` - ペット情報削除

    # wansanpo メッセージ

# - GET - `/sanpo/message/:id` - メッセージ詳細
# - GET - `/sanpo/message/create` - メッセージを新規作成する画面
# - POST - `/sanpo/message` - メッセージ新規登録実行
# - GET - `/sanpo/message/:id/edit` - メッセージを編集する画面
# - POST - `/sanpo/message/:id/update` - メッセージを更新実行
# - GET - `/sanpo/message/search` - メッセージ情報検索画面
# - POST - `/sanpo/message/:id/remove` - メッセージ情報削除

    # 預け、預かり

   # - GET - `/sanpo/deposit/:id` - 預け、預かり詳細
   # - GET - `/sanpo/deposit/create` - 預け依頼を新規作成する画面
   # - POST - `/sanpo/deposit` - 預け依頼新規登録実行
   # - GET - `/sanpo/deposit/:id/edit` - 預け依頼を編集する画面
   # - POST - `/sanpo/deposit/:id/update` - 預け依頼を更新実行
   # - GET - `/sanpo/deposit/search` - 預け、預かり情報検索画面
   # - POST - `/sanpo/deposit/:id/remove` - 預け、預かり情報削除
}

1;
