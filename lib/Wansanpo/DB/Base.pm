package Wansanpo::DB::Base;
use Mojo::Base -base;
use Wansanpo::Util qw{now_datetime};
use Teng;
use Teng::Schema::Loader;
Teng->load_plugin('Pager');

has [qw{conf}];

sub teng {
    my $self = shift;
    my $conf = $self->conf->{db};

    my $dsn_str = $conf->{dsn_str};
    my $user    = $conf->{user};
    my $pass    = $conf->{pass};
    my $option  = $conf->{option};
    my $dbh     = DBI->connect( $dsn_str, $user, $pass, $option );
    my $teng    = Teng::Schema::Loader->load(
        dbh       => $dbh,
        namespace => 'Wansanpo::DB::Teng',
    );
    return $teng;
}

# teng fast insert 日付つき
sub teng_fast_insert {
    my $self   = shift;
    my $table  = shift;
    my $params = shift;

    $params = +{
        %{$params},
        created_ts  => now_datetime(),
        modified_ts => now_datetime(),
    };
    return $self->teng->fast_insert( $table, $params );
}

# teng update 日付つき
sub teng_update {
    my $self   = shift;
    my $table  = shift;
    my $params = shift;
    my $cond   = shift;

    $params = +{ %{$params}, modified_ts => now_datetime(), };
    my $update_count = $self->teng->update( $table, $params, $cond, );
    return $cond->{id} if $update_count;
    return;
}

1;

__END__

=encoding utf8

=head1 NAME

Wansanpo::DB::Base - データベースオブジェクト (共通)

=cut
