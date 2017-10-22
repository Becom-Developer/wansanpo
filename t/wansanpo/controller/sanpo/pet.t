use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use Mojo::Util qw{dumper};
use t::Util;

my $test_util = t::Util->new();
my $t         = $test_util->init;

# ルーティング (ステータスのみ)
subtest 'router' => sub {
    my $dummy_id = 9999;
    $test_util->login($t);
    $t->ua->max_redirects(1);
    $t->get_ok("/sanpo/pet/$dummy_id")->status_is(200);
    $t->get_ok("/sanpo/pet/$dummy_id/edit")->status_is(200);
    $t->get_ok("/sanpo/pet/create")->status_is(200);
    $t->post_ok("/sanpo/pet")->status_is(200);
    $t->get_ok("/sanpo/pet/search")->status_is(200);
    $t->post_ok("/sanpo/pet/$dummy_id/update")->status_is(200);
    $t->post_ok("/sanpo/pet/$dummy_id/remove")->status_is(200);
    $t->ua->max_redirects(0);
    $test_util->logout($t);
};

# ペット情報詳細
subtest 'get /sanpo/pet/:id show' => sub {

    # ログインをする
    $test_util->login($t);
    subtest 'template' => sub {

        # ログイン中はユーザーID取得できる
        my $pet_rows = $t->app->login_user->search_pet;
        is( scalar @{$pet_rows}, 1, 'count' );
        my $pet_row    = shift @{$pet_rows};
        my $pet_id     = $pet_row->id;
        my $url        = "/sanpo/pet/$pet_id";
        my $update_url = "/sanpo/pet/$pet_id/update";
        $t->get_ok($url)->status_is(200);

        # 画像アップロード
        my $icon_form
            = "form[name=icon_update][method=post][enctype=multipart/form-data][action=$update_url]";
        $t->element_exists($icon_form);

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
    $test_util->login($t);
    subtest 'template' => sub {

        # ログイン中はユーザーID取得できる
        my $pet_rows = $t->app->login_user->search_pet;
        is( scalar @{$pet_rows}, 1, 'count' );
        my $pet_row    = shift @{$pet_rows};
        my $pet_id     = $pet_row->id;
        my $edit_url   = "/sanpo/pet/$pet_id/edit";
        my $update_url = "/sanpo/pet/$pet_id/update";
        my $show_url   = "/sanpo/pet/$pet_id";

        # 編集画面
        $t->get_ok($edit_url)->status_is(200);
        $t->text_like( 'html head title', qr{\Qwansanpo/pet/edit\E}, );

        # form
        my $form = "form[name=form_update][method=post][action=$update_url]";
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
        $t->element_exists("a[href=$show_url]");
    };
    $test_util->logout($t);
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
    $t->app->commands->run('generate_db');
    $test_util->login($t);
    subtest 'fail' => sub {
        my $teng     = $t->app->test_db->teng;
        my $pet_rows = $t->app->login_user->search_pet;
        is( scalar @{$pet_rows}, 1, 'count' );
        my $pet_row  = shift @{$pet_rows};
        my $pet_id   = $pet_row->id;
        my $edit_url = "/sanpo/pet/$pet_id/edit";
        my $show_url = "/sanpo/pet/$pet_id";
        my $action   = "/sanpo/pet/$pet_id/update";
        my $name     = 'form_update';

        # 編集画面
        $t->get_ok($edit_url)->status_is(200);

        my $dom        = $t->tx->res->dom;
        my $form       = "form[name=$name][method=post][action=$action]";
        my $update_url = $dom->at($form)->attr('action');

        # input val 取得
        my $params = $test_util->get_input_val( $dom, $form );

        # 名前 (必須項目)
        my $name_org  = $params->{name};
        my $test_name = '';
        $params->{name} = $test_name;

        # 更新実行
        $t->post_ok( $update_url => form => $params )->status_is(200);

        # 画面確認
        $t->text_like( 'html head title', qr{\Qwansanpo/pet/edit\E}, );
        $t->content_like(qr{\Q<b>更新できません</b>\E});

        # db 確認
        my $row = $teng->single( 'pet', +{ id => $pet_id } );
        is( $row->name, $name_org, 'name' );
    };

    subtest 'success' => sub {
        my $teng     = $t->app->test_db->teng;
        my $pet_rows = $t->app->login_user->search_pet;
        is( scalar @{$pet_rows}, 1, 'count' );
        my $pet_row  = shift @{$pet_rows};
        my $pet_id   = $pet_row->id;
        my $edit_url = "/sanpo/pet/$pet_id/edit";

        my $action = "/sanpo/pet/$pet_id/update";
        my $name   = 'form_update';

        # 編集画面
        $t->get_ok($edit_url)->status_is(200);

        my $dom        = $t->tx->res->dom;
        my $form       = "form[name=$name][method=post][action=$action]";
        my $update_url = $dom->at($form)->attr('action');

        # input val 取得
        my $params = $test_util->get_input_val( $dom, $form );

        # 名前更新
        my $test_name = 'sample_name';
        $params->{name} = $test_name;

        # 更新実行
        $t->post_ok( $update_url => form => $params )->status_is(302);

        # 画面確認
        my $location_url = $t->tx->res->headers->location;
        $t->get_ok($location_url)->status_is(200);
        $t->text_like( 'html head title', qr{\Qwansanpo/pet/show\E}, );
        $t->content_like(qr{\Q<b>ペット更新完了しました</b>\E});

        # db 確認
        my $row = $teng->single( 'pet', +{ id => $pet_id } );
        is( $row->name, $test_name, 'name' );
    };

    subtest 'success icon' => sub {

        # ログイン中はユーザーID取得できる
        my $teng     = $t->app->test_db->teng;
        my $pet_rows = $t->app->login_user->search_pet;
        is( scalar @{$pet_rows}, 1, 'count' );
        my $pet_row  = shift @{$pet_rows};
        my $pet_id   = $pet_row->id;
        my $icon_org = $pet_row->icon;
        my $show_url = "/sanpo/pet/$pet_id";

        # 詳細画面
        $t->get_ok($show_url)->status_is(200);

        # 画像アップロード
        my $dom        = $t->tx->res->dom;
        my $form       = 'form[name=icon_update]';
        my $update_url = $dom->at($form)->attr('action');
        my $type       = $dom->at($form)->attr('enctype');

        # アップロードファイル取得

        # ファイルを捕まえる
        my $home    = $t->app->home;
        my $path    = $home->rel_file('t/img/icon/admin.jpg');
        my $file    = $path->to_string;
        my $headers = +{ 'Content-Type' => $type };
        my $upload  = +{ icon => +{ file => $file, }, };

        $t->post_ok( $update_url => $headers => form => $upload );

        # 画面確認
        my $location_url = $t->tx->res->headers->location;
        $t->get_ok($location_url)->status_is(200);
        $t->text_like( 'html head title', qr{\Qwansanpo/pet/show\E}, );
        $t->content_like(qr{\Q<b>アイコンを更新しました</b>\E});

        # db 確認
        my $row = $teng->single( 'pet', +{ id => $pet_id } );
        isnt( $row->icon, $icon_org, 'icon' );
    };

    $test_util->logout($t);
};

# ペット情報削除
subtest 'post /sanpo/pet/:id/remove remove' => sub {
    ok(1);
};

done_testing();

__END__

package Wansanpo::Controller::Sanpo::Pet;
