package Wansanpo::Controller::Auth;
use Mojo::Base 'Mojolicious::Controller';

sub entry {
    my $self = shift;
    $self->render(text => 'test entry');
    return;
}

sub login {
    my $self = shift;
    $self->render(text => 'test login');
    return;
}

sub logout {
    my $self = shift;
    $self->render(text => 'test logout');
    return;
}

1;

__END__
