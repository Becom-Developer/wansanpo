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

done_testing();

__END__

package Wansanpo::Controller::Sanpo::Profile;
