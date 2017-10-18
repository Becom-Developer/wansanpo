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
    $t->get_ok("/sanpo/profile/$dummy_id")->status_is(200);
    $t->get_ok("/sanpo/profile/$dummy_id/edit")->status_is(200);
    $t->get_ok("/sanpo/profile/search")->status_is(200);
    $t->post_ok("/sanpo/profile/$dummy_id/update")->status_is(200);
    $t->post_ok("/sanpo/profile/$dummy_id/remove")->status_is(200);
    $t->ua->max_redirects(0);
    $test_util->logout($t);
};

subtest 'show' => sub {

    # ログインをする
    $test_util->login($t);
    subtest 'template' => sub {

        # ログイン中はユーザーID取得できる
        my $profile    = $t->app->login_user->fetch_profile;
        my $profile_id = $profile->id;
        my $user_id    = $profile->user_id;
        my $url        = "/sanpo/profile/$profile_id";
        my $update_url = "/sanpo/profile/$profile_id/update";
        $t->get_ok($url)->status_is(200);

        # 画像アップロード
        my $icon_form
            = "form[name=icon_update][method=post][enctype=multipart/form-data][action=$update_url]";
        $t->element_exists($icon_form);

        # 主な部分のみ
        # ボタン確認 編集画面, 検索, メニュー
        my $name = $profile->name;
        $t->content_like(qr{\Q$name\E});
        $t->element_exists("a[href=/sanpo/profile/$profile_id/edit]");
        $t->element_exists("a[href=/sanpo/pet/create]");
        $t->element_exists("a[href=/sanpo/profile/search]");
        $t->element_exists("a[href=/sanpo/menu]");
        $t->element_exists_not("a[href=/sanpo/message/create/$user_id]");
    };

    # ログアウトをする
    $test_util->logout($t);

    # 指定をしてログイン
    $test_util->login( $t, 2 );

    # ログイン者以外のユーザーへはメッセージを送れる
    subtest 'template logout' => sub {
        my $login_profile    = $t->app->login_user->fetch_profile;
        my $login_profile_id = $login_profile->id;

        # 見ているユーザー情報
        my $user = $t->app->test_db->teng->single( 'user', +{ id => 1 } );
        my $profile = $user->fetch_profile;
        my $profile_id = $profile->id;
        my $user_id    = $profile->user_id;

        my $url = "/sanpo/profile/$profile_id";
        $t->get_ok($url)->status_is(200);

        # 主な部分のみ
        # ボタン確認 編集画面, 検索, メニュー
        my $name = $profile->name;
        $t->content_like(qr{\Q$name\E});
        $t->element_exists_not("a[href=/sanpo/profile/$profile_id/edit]");
        $t->element_exists_not("a[href=/sanpo/pet/create]");
        $t->element_exists("a[href=/sanpo/profile/search]");
        $t->element_exists("a[href=/sanpo/menu]");
        $t->element_exists("a[href=/sanpo/message/create/$user_id]");
    };
    $test_util->logout($t);
};

subtest 'search' => sub {

    # ログインをする
    $test_util->login($t);
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
    $test_util->logout($t);
};

subtest 'edit' => sub {

    # ログインをする
    $test_util->login($t);
    subtest 'template' => sub {

        # ログイン中はユーザーID取得できる
        my $profile_id = $t->app->login_user->fetch_profile->id;
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
    $test_util->logout($t);
};

# ユーザー情報更新実行
subtest 'update' => sub {

    $test_util->login($t);
    subtest 'fail' => sub {

        # ログイン中はユーザーID取得できる
        my $teng       = $t->app->test_db->teng;
        my $profile_id = $t->app->login_user->fetch_profile->id;
        my $edit_url   = "/sanpo/profile/$profile_id/edit";

        # 編集画面
        $t->get_ok($edit_url)->status_is(200);

        my $dom        = $t->tx->res->dom;
        my $form       = 'form[name=form_update]';
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
        $t->text_like( 'html head title', qr{\Qwansanpo/profile/edit\E}, );
        $t->content_like(qr{\Q<b>更新できません</b>\E});

        # db 確認
        my $row = $teng->single( 'profile', +{ id => $profile_id } );
        is( $row->name, $name_org, 'name' );
    };

    subtest 'success' => sub {

        # ログイン中はユーザーID取得できる
        my $teng       = $t->app->test_db->teng;
        my $profile_id = $t->app->login_user->fetch_profile->id;
        my $edit_url   = "/sanpo/profile/$profile_id/edit";

        # 編集画面
        $t->get_ok($edit_url)->status_is(200);

        my $dom        = $t->tx->res->dom;
        my $form       = 'form[name=form_update]';
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
        $t->text_like( 'html head title', qr{\Qwansanpo/profile/show\E}, );
        $t->content_like(qr{\Q<b>ユーザー更新完了しました</b>\E});

        # db 確認
        my $row = $teng->single( 'profile', +{ id => $profile_id } );
        is( $row->name, $test_name, 'name' );
    };

    subtest 'success icon' => sub {

        # ログイン中はユーザーID取得できる
        my $teng       = $t->app->test_db->teng;
        my $profile_id = $t->app->login_user->fetch_profile->id;
        my $edit_url   = "/sanpo/profile/$profile_id/edit";
        my $show_url   = "/sanpo/profile/$profile_id";

        # 詳細画面
        $t->get_ok($show_url)->status_is(200);

        # 画像アップロード
        my $dom        = $t->tx->res->dom;
        my $form       = 'form[name=icon_update]';
        my $update_url = $dom->at($form)->attr('action');
        my $type       = $dom->at($form)->attr('enctype');

        # アップロードファイル取得

        # ファイルを捕まえる
        my $home = $t->app->home;
        my $path =  $home->rel_file('public/img/icon/admin.jpg');
        my $file    = $path->to_string;
        my $headers = +{ 'Content-Type' => $type };
        my $upload  = +{ icon => +{ file => $file, }, };

        $t->post_ok( $update_url => $headers => form => $upload );

        # # input val 取得
        # my $params = $test_util->get_input_val( $dom, $form );

        # # 名前更新
        # my $test_name = 'sample_name';
        # $params->{name} = $test_name;

        # # 更新実行
        # $t->post_ok( $update_url => form => $params )->status_is(302);

        # # Test file upload
        # my $upload = {foo => {content => 'bar', filename => 'baz.txt'}};
        # $t->post_ok('/upload' => form => $upload)->status_is(200);

      # # 画面確認
      # my $location_url = $t->tx->res->headers->location;
      # $t->get_ok($location_url)->status_is(200);
      # $t->text_like( 'html head title', qr{\Qwansanpo/profile/show\E}, );
      # $t->content_like(qr{\Q<b>ユーザー更新完了しました</b>\E});

        # # db 確認
        # my $row = $teng->single( 'profile', +{ id => $profile_id } );
        # is( $row->name, $test_name, 'name' );
    };

    $test_util->logout($t);
};

# ユーザー情報削除(退会)
subtest 'remove' => sub {
    ok(1);
};

done_testing();

__END__

package Wansanpo::Controller::Sanpo::Profile;
