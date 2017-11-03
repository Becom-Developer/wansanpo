package Wansanpo::Controller::Info;
use Mojo::Base 'Wansanpo::Controller::Base';

# info 現状のレポート
sub index {
    my $self = shift;
    $self->stash( class_active => +{ index => 'active' } );
    $self->render(
        template => 'info/index',
        format   => 'html',
        handler  => 'ep',
    );
    return;
}

# wansanpo 紹介
sub intro {
    my $self = shift;
    $self->stash(
        class_active => +{
            wansanpo => 'active',
            intro    => 'active',
        }
    );
    $self->render(
        template => 'info/intro',
        format   => 'html',
        handler  => 'ep',
    );
    return;
}

1;
