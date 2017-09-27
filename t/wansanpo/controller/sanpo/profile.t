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

        my $edit_url   = "/sanpo/profile/$profile_id/edit";
        my $update_url = "/sanpo/profile/$profile_id/update";
        my $show_url   = "/sanpo/profile/$profile_id";

        # 編集画面
        $t->get_ok($edit_url)->status_is(200);

        # form
        my $form = "form[name=form_update][method=post][action=$update_url]";
        $t->element_exists($form);

        # input text
        my $text_names
            = [qw{name rubi nickname email tel birthday zipcode address}];
        for my $name ( @{$text_names} ) {
            $t->element_exists("$form input[name=$name][type=text]");
        }

        # input radio
        $t->element_exists("$form input[name=gender][type=radio][value=1]");
        $t->element_exists("$form input[name=gender][type=radio][value=2]");

        # 他 button, link
        $t->element_exists("$form button[type=submit]");
        $t->element_exists("a[href=$show_url]");

    };

    # ログアウトをする
    t::Util::logout($t);
};

# ユーザー情報更新実行
subtest 'update' => sub {

    t::Util::login($t);
    subtest 'fail' => sub {
        ok(1);
    };

    subtest 'success' => sub {

        # ログイン中はユーザーID取得できる
        my $login_user = $t->app->login_user;
        my $cond       = +{ user_id => $login_user->id };
        my $profile    = $t->app->test_db->teng->single( 'profile', $cond );
        my $profile_id = $profile->id;
        my $edit_url   = "/sanpo/profile/$profile_id/edit";

        # 編集画面
        $t->get_ok($edit_url)->status_is(200);

        my $dom        = $t->tx->res->dom;
        my $form       = 'form[name=form_update]';
        my $update_url = $dom->at($form)->attr('action');

        # input text 取得
        my $params = +{};
        for my $e ( $dom->find("$form input[type=text]")->each ) {
            my $name = $e->attr('name');
            next if !$name;
            $params->{$name} = $e->val;
        }

        # input radio 取得
        for my $e ( $dom->find("$form input[type=radio]")->each ) {
            my $name = $e->attr('name');
            next if !$name;
            my $tag = $e->to_string;
            if ( $tag =~ /checked/ ) {
                $params->{$name} = $e->val;
            }
        }

        # 更新実行
        $t->post_ok( $update_url => form => $params )->status_is('200');
    };

    t::Util::logout($t);

    ok(1);
};

# ユーザー情報削除(退会)
subtest 'remove' => sub {
    ok(1);
};

done_testing();

__END__

package Wansanpo::Controller::Sanpo::Profile;
