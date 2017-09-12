package Wansanpo::Controller::Info;
use Mojo::Base 'Mojolicious::Controller';

sub index {
    my $self = shift;
    $self->render(
        template => 'info/index',
        format   => 'html',
        handler  => 'ep',
    );
    return;
}

1;
