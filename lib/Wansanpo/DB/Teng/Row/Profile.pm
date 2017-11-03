package Wansanpo::DB::Teng::Row::Profile;
use Mojo::Base 'Teng::Row';

=encoding utf8

=head1 NAME

Wansanpo::DB::Teng::Row::Profile - Teng Row オブジェクト拡張

=cut

# 呼び出しテスト
sub welcome {
    my $self = shift;
    return 'welcome Wansanpo::DB::Teng::Row::Profile!!';
}

sub fetch_user {
    my $self = shift;
    my $cond = +{ id => $self->user_id, deleted => 0, };
    return $self->handle->single( 'user', $cond );
}

sub search_pet {
    my $self = shift;
    my $cond = +{ user_id => $self->user_id, deleted => 0, };
    my @rows = $self->handle->search( 'pet', $cond );
    return \@rows;
}

1;

__END__

