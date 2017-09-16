package Wansanpo::Util;
use Mojo::Base -base;
use Time::Piece;
use Exporter 'import';
our @EXPORT_OK = qw{
    now_datetime
};

=encoding utf8

=head1 NAME

Wansanpo::Util - ユーティリティー

=cut

sub now_datetime {
    my $t    = localtime;
    my $date = $t->date;
    my $time = $t->time;
    return "$date $time";
}

1;

__END__
