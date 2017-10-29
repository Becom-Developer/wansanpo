package Wansanpo::Controller::Sanpo::Deposit;
use Mojo::Base 'Wansanpo::Controller';

sub welcome {
    my $self = shift;
    $self->render(text => 'welcome');
}

1;
