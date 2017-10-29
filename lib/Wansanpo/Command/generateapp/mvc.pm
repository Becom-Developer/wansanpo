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
    my $controller      = join '::', $appclass, 'Controller', @class_names;
    my $controller_file = class_to_path $controller;
    my $controller_args = +{
        class   => $controller,
        appname => $appclass,
    };
    $self->render_to_rel_file( 'controller', "lib/$controller_file",
        $controller_args );

    # Test
    my $test_name = lc join '/', split '::', $controller;
    my $test_file = $test_name . '.t';
    $self->render_to_rel_file( 'test', "t/$test_file" );

    # Templates
    my $templates_name = lc join '/', @class_names, 'welcome';
    my $templates_file = $templates_name . '.html.ep';
    $self->render_to_rel_file( 'welcome', "templates/$templates_file" );

    # Model
    my $model      = join '::', $appclass, 'Model', @class_names;
    my $model_file = class_to_path $model;
    my $model_args = +{
        class   => $model,
        appname => $appclass,
    };
    $self->render_to_rel_file( 'model', "lib/$model_file", $model_args );

    # Doc
    my $doc_name = lc join '/', split '::', $controller;
    my $doc_file = $doc_name . '.md';
    my $doc_args = +{
        name       => $doc_name,
        appname    => $appclass,
        controller => $controller_file,
        model      => $model_file,
        templates  => $templates_file,
        test       => $test_file,
    };
    $self->render_to_rel_file( 'doc', "doc/$doc_file", $doc_args );
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
% my $args = shift;
package <%= $args->{class} %>;
use Mojo::Base '<%= $args->{appname} %>::Controller';

sub welcome {
    my $self = shift;
    $self->render(text => 'welcome');
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

@@ model
% my $args = shift;
package <%= $args->{class} %>;
use Mojo::Base '<%= $args->{appname} %>::Model::Base';

sub welcome {
    my $self = shift;
    return;
}

1;

@@ doc
% my $args = shift;
# NAME

<%= $args->{name} %> - <%= $args->{appname} %>

# SYNOPSIS

## URL

# DESCRIPTION

# TODO

# SEE ALSO

- `lib/<%= $args->{controller} %>` -
- `lib/<%= $args->{model} %>` -
- `templates/<%= $args->{templates} %>` -
- `t/<%= $args->{test} %>` -
