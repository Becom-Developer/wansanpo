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

1;

__END__

