package Wansanpo::Command::generateapp::upload_sample;
use Mojo::Base 'Mojolicious::Command';

has description => 'Wansanpo create upload sample data';
has usage => sub { encode( shift->extract_usage ) };
has [qw{}];

sub run {
    my $self = shift;
    my $home = $self->app->home;

    # アップロード場所 (存在しない場合は作成)
    my $upload_dir = $home->path('public/var/icon')->make_path->to_string;

    # オリジナルサンプルをコピー
    for my $file ( $home->path('doc/img/icon')->list->each ) {
        $file->copy_to($upload_dir);
    }

    # 採用された dog
    for my $file ( $home->path('doc/img/dog')->list->each ) {
        $file->copy_to($upload_dir);
    }
    return;
}

1;

__END__

=encoding utf8

=head1 NAME

Wansanpo::Command::generateapp::upload_sample - Wansanpo upload sample data

=head1 SYNOPSIS

  Usage: carton exec -- script/wansanpo generateapp upload_sample [OPTIONS]

  Options:
    -m, --mode   Does something.

    # 開発用 (mode 指定なし) -> /db/wansanpo.development.db
    $ carton exec -- script/wansanpo generateapp upload_sample

    # 本番用 -> /db/wansanpo.production.db
    $ carton exec -- script/wansanpo generateapp upload_sample --mode production

    # テスト用 -> /db/wansanpo.testing.db
    $ carton exec -- script/wansanpo generateapp upload_sample --mode testing

    # 開発用 -> /db/wansanpo.development.db
    $ carton exec -- script/wansanpo generateapp upload_sample --mode development

=head1 DESCRIPTION

=cut
