package Wansanpo::Command::generateapp::upload_sample;
use Mojo::Base 'Mojolicious::Command';

has description => 'Wansanpo create upload sample data';
has usage => sub { shift->extract_usage };
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

    $ carton exec -- script/wansanpo generateapp upload_sample

=head1 DESCRIPTION

=cut
