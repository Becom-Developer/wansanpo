package Wansanpo::Model::Base;
use Mojo::Base -base;
use Mojo::Util qw{dumper};
use Wansanpo::DB;
use Mojolicious::Validator;

=encoding utf8

=head1 NAME

Wansanpo::Model::Base - コントローラーモデル (共通)

=cut

has [qw{conf req_params}];

has db => sub {
    Wansanpo::DB->new( +{ conf => shift->conf } );
};

# 呼び出しテスト
sub welcome {
    my $self = shift;
    return 'welcome Wansanpo::Model::Base!!';
}

1;

__END__
