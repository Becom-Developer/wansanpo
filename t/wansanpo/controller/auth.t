use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use Data::Dumper;

# テスト共通
use t::Util;
my $t = t::Util::init();

# ルーティング (ステータスのみ)
subtest 'router' => sub {

    # 302リダイレクトレスポンスの許可
    $t->ua->max_redirects(1);

    $t->get_ok('/auth/entry')->status_is(200);
    $t->post_ok('/auth/entry')->status_is(200);
    $t->get_ok('/auth/login')->status_is(200);
    $t->post_ok('/auth/login')->status_is(200);
    $t->post_ok('/auth/logout')->status_is(200);

    # 必ず戻す
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
        ok($user);
    };
};

# ログイン
subtest '/auth/login' => sub {

    # ログイン画面
    subtest 'template' => sub {
        $t->get_ok('/auth/login')->status_is(200);
        $t->element_exists('form[method=post][action=/auth/login]');
        $t->element_exists('input[name=login_id]');
        $t->element_exists('input[name=password]');
    };

    # ログイン実行
    subtest 'login success' => sub {
        my $user   = $t->app->test_db->teng->single( 'user', +{ id => 1 } );
        my $url    = '/auth/login';
        my $params = +{
            login_id => $user->login_id,
            password => $user->password,
        };
        $t->post_ok( $url => form => $params )->status_is(302);
        my $location_url = $t->tx->res->headers->location;
        $t->get_ok($location_url)->status_is(200);
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

done_testing();

__END__

package Wansanpo::Controller::Auth;
