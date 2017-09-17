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

subtest 'show' => sub {

    # ログインをする
    t::Util::login($t);
    subtest 'template' => sub {

        # ログイン中はユーザーID取得できる
        my $login_user = $t->app->login_user;
        my $cond       = +{ user_id => $login_user->id };
        my @pet_rows   = $t->app->test_db->teng->search( 'pet', $cond );
        is( scalar @pet_rows, 1, 'count' );
        my $pet_row = shift @pet_rows;
        my $pet_id = $pet_row->id;
        my $url        = "/sanpo/pet/$pet_id";
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

done_testing();

__END__

package Wansanpo::Controller::Sanpo::Profile;
