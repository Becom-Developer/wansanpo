package Wansanpo::DB::Teng::Row::Message;
use Mojo::Base 'Teng::Row';

=encoding utf8

=head1 NAME

Wansanpo::DB::Teng::Row::Message - Teng Row オブジェクト拡張

=cut

# to_user_id の詳細を取得
sub fetch_to_user_row {
    my $self = shift;
    my $cond = +{ id => $self->to_user_id, deleted => 0, };
    return $self->handle->single( 'user', $cond );
}

# from_user_id の詳細を取得
sub fetch_from_user_row {
    my $self = shift;
    my $cond = +{ id => $self->from_user_id, deleted => 0, };
    return $self->handle->single( 'user', $cond );
}

1;

__END__

