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
    $t->get_ok("/sanpo/message/$dummy_id")->status_is(200);
    $t->get_ok("/sanpo/message/create/$dummy_id")->status_is(200);
    $t->post_ok("/sanpo/message")->status_is(200);
    $t->get_ok("/sanpo/message/$dummy_id/edit")->status_is(200);
    $t->post_ok("/sanpo/message/$dummy_id/update")->status_is(200);
    $t->get_ok("/sanpo/message/search")->status_is(200);
    $t->get_ok("/sanpo/message/list/$dummy_id")->status_is(200);
    $t->post_ok("/sanpo/message/$dummy_id/remove")->status_is(200);
    $t->ua->max_redirects(0);
    $test_util->logout($t);
};

# メッセージ詳細
subtest 'get_ok /sanpo/message/:id show' => sub {
    $test_util->login($t);
    subtest 'template' => sub {
        ok(1);
    };
    subtest 'fail' => sub {
        ok(1);
    };
    subtest 'success' => sub {
        ok(1);
    };
    $test_util->logout($t);
};

# メッセージを新規作成する画面
subtest 'get_ok /sanpo/message/create/:id create' => sub {
    subtest 'template' => sub {
        my $user_id = 2;
        $test_util->login( $t, $user_id );

        # user 3 とのやりとり
        my $friend_user_id = 3;
        my $friend_user    = $t->app->test_db->teng->single( 'user',
            +{ id => $friend_user_id } );

        my $friend_profile_id = $friend_user->fetch_profile->id;
        my $list_url          = "/sanpo/message/list/$friend_profile_id";
        my $create_url        = "/sanpo/message/create/$friend_profile_id";

        my $name   = 'form_create';
        my $action = '/sanpo/message';

        my $menu_url = '/sanpo/menu';

        # メッセージリスト画面
        $t->get_ok($list_url)->status_is(200);
        $t->text_like( 'html head title', qr{\Qwansanpo/message/list\E}, );
        $t->element_exists("a[href=$create_url]");

        # 入力画面
        $t->get_ok($create_url)->status_is(200);
        $t->text_like( 'html head title', qr{\Qwansanpo/message/create\E}, );

        # form
        my $form = "form[name=$name][method=post][action=$action]";
        $t->element_exists($form);

        # input hidden
        my $hiden_data = [
            +{  name  => 'to_user_id',
                value => $friend_user_id,
            },
            +{  name  => 'from_user_id',
                value => $user_id,
            },
        ];
        for my $data ( @{$hiden_data} ) {
            my $name  = $data->{name};
            my $value = $data->{value};
            $t->element_exists(
                "$form input[name=$name][type=hidden][value=$value]");
        }

        # textarea
        my $textarea_names = [qw{message}];
        for my $name ( @{$textarea_names} ) {
            $t->element_exists("$form textarea[name=$name]");
        }

        # 他 button, link
        $t->element_exists("$form button[type=submit]");
        $t->element_exists("a[href=$menu_url]");
        $test_util->logout($t);
    };
    subtest 'fail' => sub {
        ok(1);
    };
    subtest 'success' => sub {
        ok(1);
    };

    # $test_util->logout($t);
};

# メッセージ新規登録実行
subtest 'post_ok /sanpo/message store' => sub {
    $test_util->login($t);
    subtest 'template' => sub {
        ok(1);
    };
    subtest 'fail' => sub {
        ok(1);
    };
    subtest 'success' => sub {
        ok(1);
    };
    $test_util->logout($t);
};

# メッセージを編集する画面
subtest 'get_ok /sanpo/message/:id/edit edit' => sub {
    $test_util->login($t);
    subtest 'template' => sub {
        ok(1);
    };
    subtest 'fail' => sub {
        ok(1);
    };
    subtest 'success' => sub {
        ok(1);
    };
    $test_util->logout($t);
};

# メッセージを更新実行
subtest 'post_ok /sanpo/message/:id/update update' => sub {
    $test_util->login($t);
    subtest 'template' => sub {
        ok(1);
    };
    subtest 'fail' => sub {
        ok(1);
    };
    subtest 'success' => sub {
        ok(1);
    };
    $test_util->logout($t);
};

# メッセージ情報検索画面
subtest 'get_ok /sanpo/message/search search' => sub {
    $test_util->login($t);
    subtest 'template' => sub {
        my $url = "/sanpo/message/search";
        $t->get_ok($url)->status_is(200);
        my $rows = $t->app->login_user->search_msg_friend_user;
        is( scalar @{$rows}, 1, 'count' );

        # 画面確認
        $t->text_like( 'html head title', qr{\Qwansanpo/message/search\E}, );

        # メッセージ一覧画面へのリンクボタン
        for my $row ( @{$rows} ) {
            my $user_id = $row->id;
            $t->element_exists("a[href=/sanpo/message/list/$user_id]");
        }
    };
    subtest 'fail' => sub {
        ok(1);
    };
    subtest 'success' => sub {
        ok(1);
    };
    $test_util->logout($t);
};

# メッセージ情報ユーザー個別に一覧表示
subtest 'get_ok /sanpo/message/list/:id list' => sub {
    subtest 'template' => sub {
        ok(1);
    };
    subtest 'fail' => sub {
        ok(1);
    };
    subtest 'success' => sub {
        my $user_id = 2;
        $test_util->login( $t, $user_id );

        # user 3 とのやりとり
        my $friend_user_id = 3;
        my $friend_user    = $t->app->test_db->teng->single( 'user',
            +{ id => $friend_user_id } );

        my $list_url   = "/sanpo/message/list/$friend_user_id";
        my $create_url = "/sanpo/message/create/$friend_user_id";

        $t->get_ok($list_url)->status_is(200);

        # 画面確認
        $t->text_like( 'html head title', qr{\Qwansanpo/message/list\E}, );

        # メッセージ新規画面へのリンクボタン
        $t->element_exists("a[href=$create_url]");

        $test_util->logout($t);
    };
};

# メッセージ情報削除
subtest 'post_ok /sanpo/message/:id/remove remove' => sub {
    $test_util->login($t);
    subtest 'template' => sub {
        ok(1);
    };
    subtest 'fail' => sub {
        ok(1);
    };
    subtest 'success' => sub {
        ok(1);
    };
    $test_util->logout($t);
};

done_testing();

__END__

package Wansanpo::Controller::Sanpo::Message;
