package Wansanpo::DB::Teng::Row::User;
use Mojo::Base 'Teng::Row';

=encoding utf8

=head1 NAME

Wansanpo::DB::Teng::Row::User - Teng Row オブジェクト拡張

=cut

# 呼び出しテスト
sub welcome {
    my $self = shift;
    return 'welcome Wansanpo::DB::Teng::Row::User!!';
}

sub fetch_profile {
    my $self = shift;
    my $cond = +{ user_id => $self->id, deleted => 0, };
    return $self->handle->single( 'profile', $cond );
}

sub search_pet {
    my $self = shift;
    my $cond = +{ user_id => $self->id, deleted => 0, };
    my @rows = $self->handle->search( 'pet', $cond );
    return \@rows;
}

# 始めてのログイン
sub is_first_login {
    my $self = shift;
    my $cond = +{ user_id => $self->id, deleted => 0, };
    my $row  = $self->handle->single( 'profile', $cond );
    return 1 if !defined $row->name || $row->name eq '';
    return;
}

1;

__END__

