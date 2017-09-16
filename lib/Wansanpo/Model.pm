package Wansanpo::Model;
use Mojo::Base 'Wansanpo::Model::Base';
use Wansanpo::Model::Auth;
use Wansanpo::Model::Info;
use Wansanpo::Model::Sanpo;

=encoding utf8

=head1 NAME

Wansanpo::Model - コントローラーモデル (呼び出し)

=cut

has auth => sub {
    Wansanpo::Model::Auth->new( +{ conf => shift->conf } );
};

has info => sub {
    Wansanpo::Model::Info->new( +{ conf => shift->conf } );
};

has sanpo => sub {
    Wansanpo::Model::Sanpo->new( +{ conf => shift->conf } );
};

# 呼び出しテスト
sub welcome {
    my $self = shift;
    return 'welcome Wansanpo::Model!!';
}

1;

__END__
