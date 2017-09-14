package Wansanpo::Controller::Sanpo;
use Mojo::Base 'Mojolicious::Controller';

# ユーザ登録画面
sub menu {
    my $self = shift;
    $self->stash(
        class_active => +{
            wansanpo => 'active',
            menu     => 'active',
        }
    );
    $self->render(
        template => 'sanpo/menu',
        format   => 'html',
        handler  => 'ep',
    );
    return;
}

1;

__END__
