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

    $t->get_ok('/sanpo/pet/1')->status_is(200);
    $t->get_ok('/sanpo/pet/1/edit')->status_is(200);
    $t->get_ok('/sanpo/pet/create')->status_is(200);
    $t->post_ok('/sanpo/pet')->status_is(200);
    $t->get_ok('/sanpo/pet/search')->status_is(200);
    $t->post_ok('/sanpo/pet/1/update')->status_is(200);
    $t->post_ok('/sanpo/pet/1/remove')->status_is(200);

    # 必ず戻す
    $t->ua->max_redirects(0);
};

# ペット情報詳細
subtest 'get /sanpo/pet/:id show' => sub {

    # ログインをする
    t::Util::login($t);
    subtest 'template' => sub {

        # ログイン中はユーザーID取得できる
        my $login_user = $t->app->login_user;
        my $cond       = +{ user_id => $login_user->id };
        my @pet_rows   = $t->app->test_db->teng->search( 'pet', $cond );
        is( scalar @pet_rows, 1, 'count' );
        my $pet_row = shift @pet_rows;
        my $pet_id  = $pet_row->id;
        my $url     = "/sanpo/pet/$pet_id";
        $t->get_ok($url)->status_is(200);

        # 主な部分のみ
        # ボタン確認 編集画面, 検索, メニュー
        my $name = $pet_row->name;
        $t->content_like(qr{\Q$name\E});
        $t->element_exists("a[href=/sanpo/pet/$pet_id/edit]");
        $t->element_exists("a[href=/sanpo/pet/search]");
        $t->element_exists("a[href=/sanpo/menu]");
    };

    # ログアウトをする
    t::Util::logout($t);
};

# ペット情報編集画面
subtest 'get /sanpo/pet/:id/edit edit' => sub {
    ok(1);
};

# ペット情報新規登録画面
subtest 'get /sanpo/pet/create create' => sub {
    t::Util::login($t);

    # 入力画面
    subtest 'template' => sub {
        my $login_user = $t->app->login_user;
        my $cond       = +{ user_id => $login_user->id };
        my $profile    = $t->app->test_db->teng->single( 'profile', $cond );
        my $profile_id = $profile->id;

        my $create_url  = '/sanpo/pet/create';
        my $name        = 'form_create';
        my $action      = '/sanpo/pet';
        my $profile_url = "/sanpo/profile/$profile_id";
        my $menu_url    = '/sanpo/menu';

        # ユーザー情報詳細画面
        $t->get_ok($profile_url)->status_is(200);
        $t->element_exists("a[href=$create_url]");

        # 入力画面
        $t->get_ok($create_url)->status_is(200);
        $t->text_like( 'html head title', qr{\Qwansanpo/pet/create\E}, );

        # form
        my $form = "form[name=$name][method=post][action=$action]";
        $t->element_exists($form);

        # input text
        my $text_names = [qw{type name birthday note}];
        for my $name ( @{$text_names} ) {
            $t->element_exists("$form input[name=$name][type=text]");
        }

        # input radio
        $t->element_exists("$form input[name=gender][type=radio][value=1]");
        $t->element_exists("$form input[name=gender][type=radio][value=2]");

        # 他 button, link
        $t->element_exists("$form button[type=submit]");
        $t->element_exists("a[href=$profile_url]");
        $t->element_exists("a[href=$menu_url]");
    };

    t::Util::logout($t);
    ok(1);
};

# ペット情報新規登録実行
subtest 'post /sanpo/pet store' => sub {
    ok(1);
};

# ペット情報検索
subtest 'get /sanpo/pet/search search' => sub {

    # ログインをする
    t::Util::login($t);
    subtest 'template' => sub {
        my $url = "/sanpo/pet/search";
        $t->get_ok($url)->status_is(200);
        my $cond = +{ deleted => 0 };
        my @pets = $t->app->test_db->teng->search( 'pet', $cond );

        # 主な部分のみ、詳細画面へのリンクボタン
        for my $pet (@pets) {
            my $id = $pet->id;
            $t->element_exists("a[href=/sanpo/pet/$id]");
        }
    };

    # ログアウトをする
    t::Util::logout($t);
};

# ペット情報更新実行
subtest 'post /sanpo/pet/:id/update update' => sub {
    ok(1);
};

# ペット情報削除
subtest 'post /sanpo/pet/:id/remove remove' => sub {
    ok(1);
};

done_testing();

__END__

package Wansanpo::Controller::Sanpo::Pet;
