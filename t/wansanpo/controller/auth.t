use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

# テスト共通
use t::Util;
my $t = t::Util::init();

ok(1);

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

done_testing();

__END__

Auth コントローラーテスト

