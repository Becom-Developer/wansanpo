package Wansanpo::Model::Sanpo;
use Mojo::Base 'Wansanpo::Model::Base';
use Wansanpo::Model::Sanpo::Profile;
use Wansanpo::Model::Sanpo::Pet;
use Wansanpo::Model::Sanpo::Message;

=encoding utf8

=head1 NAME

Wansanpo::Model::Sanpo - コントローラーモデル

=cut

has profile => sub {
    Wansanpo::Model::Sanpo::Profile->new( +{ conf => shift->conf } );
};

has pet => sub {
    Wansanpo::Model::Sanpo::Pet->new( +{ conf => shift->conf } );
};

has message => sub {
    Wansanpo::Model::Sanpo::Message->new( +{ conf => shift->conf } );
};

# 呼び出しテスト
sub welcome {
    my $self = shift;
    return 'welcome Wansanpo::Model::Sanpo!!';
}

1;

__END__
