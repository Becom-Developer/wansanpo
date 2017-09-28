package t::Util;
use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use Mojo::Util qw{dumper};
use Wansanpo::DB;

=encoding utf8

=head1 NAME

t::Util - テストコードユーティリティ

=cut

# データ初期化など
sub init {

    # app 実行前に mode 切り替え conf が読まれなくなる
    $ENV{MOJO_MODE} = 'testing';
    my $t = Test::Mojo->new('Wansanpo');

    # testing 以外では実行不可
    die 'not testing mode' if $t->app->mode ne 'testing';

    # テスト用DB初期化
    $t->app->commands->run('generate_db');
    $t->app->helper(
        test_db => sub { Wansanpo::DB->new( +{ conf => $t->app->config } ) }
    );
    return $t;
}

# ログインする
sub login {
    my $t = shift;

    # テスト用の user データの存在確認
    my $row = $t->app->test_db->teng->single( 'user', +{ id => 1 } );
    ok($row);

    my $params = +{
        login_id => $row->login_id,
        password => $row->password,
    };

    # 302リダイレクトレスポンスの許可
    $t->ua->max_redirects(1);
    $t->post_ok( '/auth/login' => form => $params )->status_is(200);
    $t->content_like(qr{\Q<b>ユーザーログインしました</b>\E});
    $t->ua->max_redirects(0);
    return;
}

# ログアウトする
sub logout {
    my $t = shift;

    # ログアウトの実行
    $t->post_ok('/auth/logout')->status_is(302);

    # リダイレクト先の確認
    my $location_url = '/info/intro';
    $t->header_is( location => $location_url );

    # リダイレクト先でアクセス後、セッション確認
    $t->get_ok($location_url)->status_is(200);
    my $session_id = $t->app->build_controller( $t->tx )->session('user');
    is( $session_id, undef, 'session_id' );
    return;
}

# input 入力フォームの値を取得
sub get_input_val {
    my $dom  = shift;
    my $form = shift;

    # input text 取得
    my $text_params = _get_input_text_val( $dom, $form );

    # input radio 取得
    my $radio_params = _get_input_radio_val( $dom, $form );
    my $params = +{ %{$text_params}, %{$radio_params}, };
    return $params;
}

# input text 入力フォームの値を取得
sub _get_input_text_val {
    my $dom  = shift;
    my $form = shift;

    my $params = +{};
    for my $e ( $dom->find("$form input[type=text]")->each ) {
        my $name = $e->attr('name');
        next if !$name;
        $params->{$name} = $e->val;
    }
    return $params;
}

# input radio 入力フォームの値を取得
sub _get_input_radio_val {
    my $dom  = shift;
    my $form = shift;

    my $params = +{};
    for my $e ( $dom->find("$form input[type=radio]")->each ) {
        my $name = $e->attr('name');
        next if !$name;
        my $tag = $e->to_string;
        if ( $tag =~ /checked/ ) {
            $params->{$name} = $e->val;
        }
    }
    return $params;
}

1;

__END__
