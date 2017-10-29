package Wansanpo::Command::generateapp::mvc;
use Mojo::Base 'Mojolicious::Command';
use Mojo::Util qw{dumper class_to_file class_to_path};

has description => 'Wansanpo create mvc';
has usage => sub { shift->extract_usage };
has [qw{}];

sub run {
    my $self        = shift;
    my @class_names = @_;
    my $home        = $self->app->home;

    my $error_msg
        = 'Your application name has to be a well formed (CamelCase) Perl module name like "MyApp". ';
    for my $name (@class_names) {
        next if $name =~ /^[A-Z](?:\w|::)+$/;
        $error_msg = "Your input name [$name] ?\n" . $error_msg;
        die $error_msg;
    }

    # app 自身のクラス名取得
    die 'Can not get class name!' if $home->path('lib')->list->size ne 1;
    my $appclass = $home->path('lib')->list->first->basename('.pm');

    # Controller
    my $controller = join '::', $appclass, 'Controller', @class_names;
    my $path = class_to_path $controller;
    $self->render_to_rel_file( 'controller', "lib/$path", $controller,
        $appclass );

    # Test
    $path = join '/', split '::', $controller;
    $path = lc $path . '.t';
    $self->render_to_rel_file( 'test', "t/$path" );

    # Templates
    $path = join '/', @class_names, 'welcome';
    $path = lc $path . '.html.ep';
    $self->render_to_rel_file( 'welcome', "templates/$path" );

    # Model
    my $model = join '::', $appclass, 'Model', @class_names;
    $path = class_to_path $model;
    $self->render_to_rel_file( 'model', "lib/$path", $model, $appclass );
    return;
}

1;

=encoding utf8

=head1 NAME

Wansanpo::Command::generateapp::mvc - Wansanpo mvc

=head1 SYNOPSIS

  Usage: carton exec -- script/wansanpo generateapp mvc [OPTIONS]

  Options:
    -m, --mode   Does something.

    # package MyApp::Controller::Auth::Test; の場合

    $ carton exec -- script/wansanpo generateapp mvc Auth Test

    # コントローラ, モデル, テンプレート, テストコードが作成

=head1 DESCRIPTION

=cut

__DATA__

@@ controller
% my $class = shift;
% my $appname = shift;
package <%= $class %>;
use Mojo::Base '<%= $appname %>::Controller';

sub welcome {
    my $self = shift;
    $self->render(text => 'welcome');
}

1;

@@ model
% my $class = shift;
% my $appname = shift;
package <%= $class %>;
use Mojo::Base '<%= $appname %>::Model::Base';

sub welcome {
    my $self = shift;
    return;
}

1;

@@ test
use Mojo::Base -strict;
use Test::More;
use Test::Mojo;
use Mojo::Util qw{dumper};
use t::Util;

my $test_util = t::Util->new();
my $t         = $test_util->init;

done_testing();

@@ welcome
%% layout '';
%% title '';
