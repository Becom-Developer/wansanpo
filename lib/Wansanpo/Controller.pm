package Wansanpo::Controller;
use Mojo::Base 'Mojolicious::Controller';
use HTML::FillInForm::Lite;
use Wansanpo::Util qw{easy_filename has_suffix_error};

sub render_fillin {
    my $self     = shift;
    my $template = shift;
    my $params   = shift;
    my $fiilin   = HTML::FillInForm::Lite->new();
    my $html     = $self->render_to_string( template => $template );
    my $output   = $fiilin->fill( \$html, $params );
    $self->render( text => $output );
    return;
}

# テンプレートに表示するパラメーター取得に失敗
sub redirect_to_error {
    my $self = shift;
    $self->flash( msg => '不正な入力' );
    $self->redirect_to("/sanpo/menu");
    return;
}

# アイコンアップロード
sub upload_icon {
    my $self         = shift;
    my $redirect_url = shift;

    my $conf = $self->app->config;
    my $icon = $self->req->upload('icon');

    # アップロードされたファイルの拡張子の判定
    if ( has_suffix_error( $icon->filename ) ) {
        $self->flash( msg => '拡張子が不正' );
        $self->redirect_to($redirect_url);
        return;
    }

    # 保存先のパス public/var/icon
    my $upload_path = $conf->{upload}->{icon};

    # 新しいファイル名
    my $save_filename = easy_filename( $icon->filename );

    # コピー先 (存在しない場合は作成)
    my $path = $self->app->home->path($upload_path);
    $path = $path->make_path->child($save_filename);

    # ファイルコピー
    $icon->move_to( $path->to_string );

    # テスト時は削除
    if ( $self->app->mode eq 'testing' ) {
        unlink $path->to_string;
    }
    return $save_filename;
}

1;

__END__
