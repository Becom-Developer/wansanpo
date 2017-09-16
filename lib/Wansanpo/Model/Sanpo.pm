package Wansanpo::Model::Sanpo;
use Mojo::Base 'Wansanpo::Model::Base';

=encoding utf8

=head1 NAME

Wansanpo::Model::Sanpo - コントローラーモデル

=cut

has profile => sub {
    HackerzLab::Model::Sanpo::Profile->new( +{ conf => shift->conf } );
};

# 呼び出しテスト
sub welcome {
    my $self = shift;
    return 'welcome Wansanpo::Model::Sanpo!!';
}

1;

__END__
