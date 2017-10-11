package Wansanpo;
use Mojo::Base 'Mojolicious';
use Wansanpo::Model;

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

    # コマンドをロードするための他の名前空間
    push @{ $self->commands->namespaces }, 'Wansanpo::Command';

    # コントローラーモデル
    $self->helper(
        model => sub { Wansanpo::Model->new( +{ conf => $config } ); } );

    # ルーティング前に共通して実行
    $self->hook(
        before_dispatch => sub {
            my $c   = shift;
            my $url = $c->req->url;

            # 認証中はアクセスできない
            if ( $url =~ m{^/auth/login} ) {
                if ( $c->session('user') ) {
                    $c->flash( msg =>
                            'ログイン中はアクセスできません' );
                    $c->redirect_to('/info/intro');
                    return;
                }
            }
            $self->helper( login_user => sub {undef} );

            # 認証保護されたページ
            if ( $url =~ m{^/sanpo} ) {

                # セッション情報からログイン者の情報を取得
                my $auth_model = $self->model->auth->req_params(
                    +{ login_id => $c->session('user') } );
                if ( my $login_user = $auth_model->session_check ) {
                    $self->helper( login_user => sub {$login_user} );
                    return;
                }

                # セッション無き場合ログインページへ
                $c->flash( msg => 'ログインが必要です' );
                $c->redirect_to('/auth/login');
                return;
            }
        }
    );

    # Router
    my $r = $self->routes;

    # 告知サイト
    $r->get('/')->to('Info#index');
    $r->get('/info')->to('Info#index');
    $r->get('/info/intro')->to('Info#intro');

    # 認証関連
    $r->get('/auth/entry')->to('Auth#create');
    $r->post('/auth/entry')->to('Auth#store');
    $r->get('/auth/login')->to('Auth#login');
    $r->post('/auth/login')->to('Auth#check');
    $r->post('/auth/logout')->to('Auth#logout');
    $r->get('/auth/:id/edit')->to('Auth#edit');
    $r->post('/auth/:id/update')->to('Auth#update');

    # 認証保護されたページ
    # アプリメニュー
    $r->get('/sanpo/menu')->to('Sanpo#menu');

    # ユーザー情報
    $r->get('/sanpo/profile/search')->to('Sanpo::Profile#search');
    $r->get('/sanpo/profile/:id')->to('Sanpo::Profile#show');
    $r->get('/sanpo/profile/:id/edit')->to('Sanpo::Profile#edit');
    $r->post('/sanpo/profile/:id/update')->to('Sanpo::Profile#update');
    $r->post('/sanpo/profile/:id/remove')->to('Sanpo::Profile#remove');

    # ペット情報
    $r->get('/sanpo/pet/:id/edit')->to('Sanpo::Pet#edit');
    $r->post('/sanpo/pet/:id/update')->to('Sanpo::Pet#update');
    $r->post('/sanpo/pet/:id/remove')->to('Sanpo::Pet#remove');
    $r->get('/sanpo/pet/create')->to('Sanpo::Pet#create');
    $r->get('/sanpo/pet/search')->to('Sanpo::Pet#search');
    $r->post('/sanpo/pet')->to('Sanpo::Pet#store');
    $r->get('/sanpo/pet/:id')->to('Sanpo::Pet#show');

    # wansanpo メッセージ
    $r->get('/sanpo/message/search')->to('Sanpo::Message#search');
    $r->get('/sanpo/message/create/:id')->to('Sanpo::Message#create');
    $r->get('/sanpo/message/:id')->to('Sanpo::Message#show');
    $r->post('/sanpo/message')->to('Sanpo::Message#store');
    $r->get('/sanpo/message/:id/edit')->to('Sanpo::Message#edit');
    $r->post('/sanpo/message/:id/update')->to('Sanpo::Message#update');
    $r->get('/sanpo/message/list/:id')->to('Sanpo::Message#list');
    $r->post('/sanpo/message/:id/remove')->to('Sanpo::Message#remove');

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
