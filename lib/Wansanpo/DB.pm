package Wansanpo::DB;
use Mojo::Base 'Wansanpo::DB::Base';

=encoding utf8

=head1 NAME

Wansanpo::DB - データベースオブジェクト (呼び出し)

=cut

# 呼び出しテスト
sub welcome {
    my $self = shift;
    return 'welcome Wansanpo::DB!!';
}

1;

__END__
