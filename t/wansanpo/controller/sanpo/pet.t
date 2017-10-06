use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use Mojo::Util qw{dumper};
use t::Util;

my $test_util = t::Util->new();
my $t         = $test_util->init;

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
    $test_util->login($t);
    subtest 'template' => sub {

        # ログイン中はユーザーID取得できる
        my $pet_rows = $t->app->login_user->search_pet;
        is( scalar @{$pet_rows}, 1, 'count' );
        my $pet_row = shift @{$pet_rows};
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
    $test_util->logout($t);
};

# ペット情報編集画面
subtest 'get /sanpo/pet/:id/edit edit' => sub {
    ok(1);
};

# ペット情報新規登録画面
subtest 'get /sanpo/pet/create create' => sub {
    $test_util->login($t);

    # 入力画面
    subtest 'template' => sub {
        my $profile_id  = $t->app->login_user->fetch_profile->id;
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
    $test_util->logout($t);
};

# ペット情報新規登録実行
subtest 'post /sanpo/pet store' => sub {
    $test_util->login($t);

    subtest 'fail' => sub {
        my $teng       = $t->app->test_db->teng;
        my $pet_rows   = $t->app->login_user->search_pet;
        my $create_url = '/sanpo/pet/create';
        my $name       = 'form_create';
        my $action     = '/sanpo/pet';

        # 入力画面
        $t->get_ok($create_url)->status_is(200);
        $t->text_like( 'html head title', qr{\Qwansanpo/pet/create\E}, );

        my $dom        = $t->tx->res->dom;
        my $form       = "form[name=$name][method=post][action=$action]";
        my $action_url = $dom->at($form)->attr('action');

        # 入力データーの元
        my $pet      = shift @{$pet_rows};
        my $pet_hash = $pet->get_columns;

        # 名前なし
        # 名前 (必須項目)
        my $name_org  = $pet_hash->{name};
        my $test_name = '';
        $pet_hash->{name} = $test_name;

        # dom に 値を埋め込み
        $dom = $test_util->input_val_in_dom( $dom, $form, $pet_hash );

        # input val 取得
        my $params = $test_util->get_input_val( $dom, $form );

        # 実行
        $t->post_ok( $action_url => form => $params )->status_is(200);

        # 画面確認
        $t->text_like( 'html head title', qr{\Qwansanpo/pet/create\E}, );
        $t->content_like(qr{\Q<b>登録できません</b>\E});

        # db 確認
        my $row = $teng->single( 'pet', +{ name => $name_org } );
        is( $row->gender, $pet_hash->{gender}, 'gender' );
    };

    subtest 'success' => sub {
        my $teng       = $t->app->test_db->teng;
        my $pet_rows   = $t->app->login_user->search_pet;
        my $create_url = '/sanpo/pet/create';
        my $name       = 'form_create';
        my $action     = '/sanpo/pet';

        # 入力画面
        $t->get_ok($create_url)->status_is(200);
        $t->text_like( 'html head title', qr{\Qwansanpo/pet/create\E}, );

        my $dom        = $t->tx->res->dom;
        my $form       = "form[name=$name][method=post][action=$action]";
        my $action_url = $dom->at($form)->attr('action');

        # 入力データーの元
        my $pet      = shift @{$pet_rows};
        my $pet_hash = $pet->get_columns;

        # test_pet メス
        $pet_hash->{name}   = 'test_pet';
        $pet_hash->{gender} = 2;

        # dom に 値を埋め込み
        $dom = $test_util->input_val_in_dom( $dom, $form, $pet_hash );

        # input val 取得
        my $params = $test_util->get_input_val( $dom, $form );

        # 実行
        $t->post_ok( $action_url => form => $params )->status_is(302);

        # 画面確認
        my $location_url = $t->tx->res->headers->location;
        $t->get_ok($location_url)->status_is(200);
        $t->text_like( 'html head title', qr{\Qwansanpo/pet/show\E}, );
        $t->content_like(qr{\Q<b>登録完了しました</b>\E});

        # db 確認
        my $row = $teng->single( 'pet', +{ name => $pet_hash->{name} } );
        is( $row->gender, $pet_hash->{gender}, 'gender' );
    };
    $test_util->logout($t);
};

# ペット情報検索
subtest 'get /sanpo/pet/search search' => sub {

    # ログインをする
    $test_util->login($t);
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
    $test_util->logout($t);
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
