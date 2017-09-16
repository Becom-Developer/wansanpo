package Wansanpo::Model::Sanpo::Profile;
use Mojo::Base 'Wansanpo::Model::Base';
use Mojo::Util qw{dumper};

=encoding utf8

=head1 NAME

Wansanpo::Model::Sanpo::Profile - コントローラーモデル

=cut

has [qw{}];

# 呼び出しテスト
sub welcome {
    my $self = shift;
    return 'welcome Wansanpo::Model::Sanpo::Profile!!';
}

1;

__END__
