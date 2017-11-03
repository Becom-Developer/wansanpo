package Wansanpo::DB::Teng::Row::Pet;
use Mojo::Base 'Teng::Row';

=encoding utf8

=head1 NAME

Wansanpo::DB::Teng::Row::Pet - Teng Row オブジェクト拡張

=cut

# 呼び出しテスト
sub welcome {
    my $self = shift;
    return 'welcome Wansanpo::DB::Teng::Row::Pet!!';
}

sub fetch_user {
    my $self = shift;
    my $cond = +{ id => $self->user_id, deleted => 0, };
    return $self->handle->single( 'user', $cond );
}

1;

__END__

