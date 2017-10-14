use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use Mojo::Util qw{dumper};
use t::Util;

my $test_util = t::Util->new();
my $t = $test_util->init;

# ルーティング (ステータスのみ)
subtest 'router' => sub {
    my $dummy_id = 9999;
    $t->ua->max_redirects(1);
    $t->get_ok("/auth/entry")->status_is(200);
    $t->post_ok("/auth/entry")->status_is(200);
    $t->get_ok("/auth/login")->status_is(200);
    $t->post_ok("/auth/login")->status_is(200);
    $t->post_ok("/auth/logout")->status_is(200);
    $t->get_ok("/auth/$dummy_id/edit")->status_is(200);
    $t->post_ok("/auth/$dummy_id/update")->status_is(200);
    $t->ua->max_redirects(0);
};

# ユーザー登録
subtest '/auth/entry' => sub {

    # エントリー画面
    subtest 'template' => sub {
        $t->get_ok('/auth/entry')->status_is(200);
        $t->element_exists('form[method=post][action=/auth/entry]');
        $t->element_exists('input[name=login_id]');
        $t->element_exists('input[name=password]');
    };

    # エントリー失敗
    subtest 'entry fail' => sub {
        my $url    = '/auth/entry';
        my $params = +{
            login_id => '',
            password => '',
        };

        # 入力値が正しくない
        $t->post_ok( $url => form => $params )->status_is(200);
        $t->content_like(qr{\Q<b>登録できません</b>\E});

        # すでに存在する
        my $user = $t->app->test_db->teng->single( 'user', +{ id => 1 } );
        $params = +{
            login_id => $user->login_id,
            password => $user->password,
        };

        $t->post_ok( $url => form => $params )->status_is(200);
        $t->content_like(qr{\Q<b>登録できません</b>\E});
    };

    # エントリー成功
    subtest 'entry success' => sub {
        my $url    = '/auth/entry';
        my $params = +{
            login_id => 'nyans@gmail.com',
            password => 'nyans',
        };
        $t->post_ok( $url => form => $params )->status_is(302);
        my $location_url = $t->tx->res->headers->location;
        $t->get_ok($location_url)->status_is(200);
        $t->content_like(qr{\Q<b>ユーザー登録完了しました</b>\E});
        my $user = $t->app->test_db->teng->single( 'user',
            +{ login_id => $params->{login_id} } );

        my $profile = $t->app->test_db->teng->single( 'profile',
            +{ user_id => $user->id } );

        ok($user);
        ok($profile);
    };
};

# ログイン
subtest '/auth/login' => sub {

    # ログイン画面
    subtest 'template' => sub {
        my $url      = '/auth/login';
        my $link_url = '/auth/entry';
        $t->get_ok($url)->status_is(200);

        # form
        my $form = "form[name=form_login][method=post][action=$url]";
        $t->element_exists($form);

        # input text
        my $text_names = [qw{login_id password}];
        for my $name ( @{$text_names} ) {
            $t->element_exists("$form input[name=$name][type=text]");
        }

        # 他 button, link
        $t->element_exists("$form button[type=submit]");
        $t->element_exists("a[href=$link_url]");
    };

    # ログイン実行
    subtest 'login success' => sub {
        my $user     = $t->app->test_db->teng->single( 'user', +{ id => 1 } );
        my $login_id = $user->login_id;
        my $password = $user->password;
        my $url      = '/auth/login';

        # ログイン画面表示
        $t->get_ok($url)->status_is(200);
        my $dom = $t->tx->res->dom;

        my $form       = 'form[name=form_login]';
        my $action_url = $dom->at($form)->attr('action');

        # 値を入力
        $dom->at('input[name=login_id]')->attr( +{ value => $login_id } );
        $dom->at('input[name=password]')->attr( +{ value => $password } );

        # input val 取得
        my $params = $test_util->get_input_val( $dom, $form );

        # ログイン実行
        $t->post_ok( $action_url => form => $params )->status_is(302);
        my $location_url = $t->tx->res->headers->location;
        $t->get_ok($location_url)->status_is(200);

        # 成功画面
        $t->content_like(qr{\Q<b>ユーザーログインしました</b>\E});
    };

    # ログイン失敗
    subtest 'login fail' => sub {
        my $url    = '/auth/login';
        my $params = +{
            login_id => '',
            password => '',
        };

        # ログイン中は info 画面にリダイレクト
        # ログイン画面
        $t->get_ok($url)->status_is(302);

        # ログイン実行
        $t->post_ok( $url => form => $params )->status_is(302);
        my $location_url = $t->tx->res->headers->location;
        $t->get_ok($location_url)->status_is(200);
        $t->content_like(
            qr{\Q<b>ログイン中はアクセスできません</b>\E});

        # ログアウト
        $t->post_ok('/auth/logout')->status_is(302);
        $location_url = $t->tx->res->headers->location;
        $t->get_ok($location_url)->status_is(200);
        $t->content_like(qr{\Q<p>お散歩わんわんの紹介</p>\E});

        # 入力値が正しくない
        $t->post_ok( $url => form => $params )->status_is(200);
        $t->content_like(qr{\Q<b>ユーザーが存在しません</b>\E});
    };
};

# ログアウト実行
subtest 'post /auth/logout' => sub {
    ok(1);
};

# パスワード変更画面
subtest 'get auth/:id/edit' => sub {
    ok(1);
};

# パスワード変更実行
subtest 'post /auth/:id/update' => sub {
    ok(1);
};

done_testing();

__END__

package Wansanpo::Controller::Auth;
