package Wansanpo::DB::Teng::Row::Pet;
use Mojo::Base 'Teng::Row';

=encoding utf8

=head1 NAME

Wansanpo::DB::Teng::Row::Pet - Teng Row オブジェクト拡張

=cut

sub fetch_user {
    my $self = shift;
    my $cond = +{ id => $self->user_id, deleted => 0, };
    return $self->handle->single( 'user', $cond );
}

1;

__END__

