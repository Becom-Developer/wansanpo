package Wansanpo::Model::Info;
use Mojo::Base 'Wansanpo::Model::Base';

=encoding utf8

=head1 NAME

Wansanpo::Model::Info - コントローラーモデル

=cut

has [qw{}];

# 呼び出しテスト
sub welcome {
    my $self = shift;
    return 'welcome Wansanpo::Model::Info!!';
}

1;

__END__
