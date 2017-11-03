package Wansanpo::DB;
use Mojo::Base 'Wansanpo::DB::Base';
use Wansanpo::DB::Master;

has master => sub { Wansanpo::DB::Master->new(); };

1;

__END__

=encoding utf8

=head1 NAME

Wansanpo::DB - データベースオブジェクト (呼び出し)

=cut
