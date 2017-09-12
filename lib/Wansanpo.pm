package Wansanpo;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
    my $self = shift;

    # Load configuration from hash returned by "my_app.conf"
    my $config = $self->plugin('Config');

    # Documentation browser under "/perldoc"
    $self->plugin('PODRenderer') if $config->{perldoc};

    # Router
    my $r = $self->routes;

    # 告知サイト
    $r->get('/')->to('Info#index');
    $r->get('/info')->to('Info#index');

    # 認証関連
    $r->get('/auth/entry')->to('Auth#entry');
    $r->post('/auth/entry')->to('Auth#entry');
    $r->get('/auth/login')->to('Auth#login');
    $r->post('/auth/login')->to('Auth#login');
    $r->post('/auth/logout')->to('Auth#logout');
}

1;
