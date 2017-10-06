use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use Mojo::Util qw{dumper};
use t::Util;

my $test_util = t::Util->new();
my $t = $test_util->init;

# ルーティング (ステータスのみ)
subtest 'router' => sub {

    # 302リダイレクトレスポンスの許可
    $t->ua->max_redirects(1);

    $t->get_ok('/sanpo/menu')->status_is(200);

    # 必ず戻す
    $t->ua->max_redirects(0);
};

done_testing();

__END__

package Wansanpo::Controller::Sanpo;
