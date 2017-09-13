package t::Util;
use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use Mojo::Util qw{dumper};

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

    # # テスト用DB初期化
    # $t->app->commands->run('generate_db');
    # $t->app->helper(
    #     test_db => sub { Wansanpo::DB->new( +{ conf => $t->app->config } ) }
    # );
    return $t;
}

1;

__END__