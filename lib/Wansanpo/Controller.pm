package Wansanpo::Controller;
use Mojo::Base 'Mojolicious::Controller';
use HTML::FillInForm::Lite;

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

1;

__END__
