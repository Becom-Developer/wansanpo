package Wansanpo::Model::Base;
use Mojo::Base -base;
use Mojo::Util qw{dumper};
use Wansanpo::DB;

has [qw{conf req_params}];

has db => sub {
    Wansanpo::DB->new( +{ conf => shift->conf } );
};

1;

__END__

=encoding utf8

=head1 NAME

Wansanpo::Model::Base - コントローラーモデル (共通)

=cut
