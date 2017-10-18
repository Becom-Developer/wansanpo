package Wansanpo::Util;
use Mojo::Base -base;
use Time::Piece;
use Exporter 'import';
our @EXPORT_OK = qw{
    now_datetime
    easy_filename
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

# 簡易的にユニークなファイル名作成
sub easy_filename {

    # 日付情報
    my $t        = localtime;
    my $datetime = $t->strftime('%Y%m%d%H%M%S');

    # 4桁の簡易的な乱数
    my $rand     = int rand(1000);
    my $id       = sprintf '%04d', $rand;
    my $filename = $datetime . '_' . $id;
    return $filename;
}

1;

__END__
