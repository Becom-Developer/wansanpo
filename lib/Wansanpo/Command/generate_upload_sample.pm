package Wansanpo::Command::generate_upload_sample;
use Mojo::Base 'Mojolicious::Command';

has description => 'Wansanpo create upload sample data';
has usage => sub { encode( shift->extract_usage ) };
has [qw{}];

sub run {
    my $self = shift;

    # サンプルデータのパス
    my $path       = $self->app->home->path('doc/img/icon');
    my $collection = $path->list;

    # アップロードデータの保存場所のパス
    my $upload_path = $self->app->home->path('public/var/icon');

    # コピー先 (存在しない場合は作成)
    my $upload_dir = $upload_path->make_path->to_string;

    # 順番にファイルコピー
    for my $file ( $collection->each ) {
        $file->copy_to($upload_dir);
    }

    # 採用された dog
    my $dog_path       = $self->app->home->path('doc/img/dog');
    my $dog_collection = $dog_path->list;
    for my $file ( $dog_collection->each ) {
        $file->copy_to($upload_dir);
    }
    return;
}

1;

__END__

=encoding utf8

=head1 NAME

Wansanpo::Command::generate_upload_sample - Wansanpo create upload sample data

=head1 SYNOPSIS

  Usage: carton exec -- script/wansanpo generate_upload_sample [OPTIONS]

  Options:
    -m, --mode   Does something.

    # 開発用 (mode 指定なし) -> /db/wansanpo.development.db
    $ carton exec -- script/wansanpo generate_upload_sample

    # 本番用 -> /db/wansanpo.production.db
    $ carton exec -- script/wansanpo generate_upload_sample --mode production

    # テスト用 -> /db/wansanpo.testing.db
    $ carton exec -- script/wansanpo generate_upload_sample --mode testing

    # 開発用 -> /db/wansanpo.development.db
    $ carton exec -- script/wansanpo generate_upload_sample --mode development

=head1 DESCRIPTION

=cut
