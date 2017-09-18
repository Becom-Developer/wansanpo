use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

# テスト共通
use t::Util;
my $t = t::Util::init();
use Data::Dumper;

# ルーティング (ステータスのみ)
subtest 'router' => sub {

    # 302リダイレクトレスポンスの許可
    $t->ua->max_redirects(1);

    $t->get_ok('/sanpo/profile/1')->status_is(200);
    $t->get_ok('/sanpo/profile/1/edit')->status_is(200);
    $t->get_ok('/sanpo/profile/search')->status_is(200);
    $t->post_ok('/sanpo/profile/1/update')->status_is(200);
    $t->post_ok('/sanpo/profile/1/remove')->status_is(200);

    # 必ず戻す
    $t->ua->max_redirects(0);
};

subtest 'show' => sub {

    # ログインをする
    t::Util::login($t);
    subtest 'template' => sub {

        # ログイン中はユーザーID取得できる
        my $login_user = $t->app->login_user;
        my $cond       = +{ user_id => $login_user->id };
        my $profile    = $t->app->test_db->teng->single( 'profile', $cond );
        my $profile_id = $profile->id;
        my $url        = "/sanpo/profile/$profile_id";
        $t->get_ok($url)->status_is(200);

        # 主な部分のみ
        # ボタン確認 編集画面, 検索, メニュー
        my $name = $profile->name;
        $t->content_like(qr{\Q$name\E});
        $t->element_exists("a[href=/sanpo/profile/$profile_id/edit]");
        $t->element_exists("a[href=/sanpo/profile/search]");
        $t->element_exists("a[href=/sanpo/menu]");
    };

    # ログアウトをする
    t::Util::logout($t);
};

subtest 'search' => sub {

    # ログインをする
    t::Util::login($t);
    subtest 'template' => sub {
        my $url = "/sanpo/profile/search";
        $t->get_ok($url)->status_is(200);
        my $cond = +{ deleted => 0 };
        my @profiles = $t->app->test_db->teng->search( 'profile', $cond );

        # 主な部分のみ、詳細画面へのリンクボタン
        for my $profile (@profiles) {
            my $id = $profile->id;
            $t->element_exists("a[href=/sanpo/profile/$id]");
        }
    };

    # ログアウトをする
    t::Util::logout($t);
};

subtest 'edit' => sub {

    # ログインをする
    t::Util::login($t);
    subtest 'template' => sub {

        # ログイン中はユーザーID取得できる
        my $login_user = $t->app->login_user;
        my $cond       = +{ user_id => $login_user->id };
        my $profile    = $t->app->test_db->teng->single( 'profile', $cond );
        my $profile_id = $profile->id;
        my $url        = "/sanpo/profile/$profile_id/edit";
        $t->get_ok($url)->status_is(200);
        warn $t->tx->res->body;
        # 主な部分のみ
        # ボタン確認 編集画面, 検索, メニュー
        # my $name = $profile->name;
        # $t->content_like(qr{\Q$name\E});
        # $t->element_exists("a[href=/sanpo/profile/$profile_id/edit]");
        # $t->element_exists("a[href=/sanpo/profile/search]");
        # $t->element_exists("a[href=/sanpo/menu]");
    };

    # ログアウトをする
    t::Util::logout($t);
};

done_testing();

__END__

package Wansanpo::Controller::Sanpo::Profile;
