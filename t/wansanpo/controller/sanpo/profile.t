use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

# テスト共通
use t::Util;
my $t = t::Util::init();

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

done_testing();

__END__

package Wansanpo::Controller::Sanpo::Profile;
