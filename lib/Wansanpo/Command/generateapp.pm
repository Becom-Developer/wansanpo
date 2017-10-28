package Wansanpo::Command::generateapp;
use Mojo::Base 'Mojolicious::Commands';

has description => 'Generate files and directories from your own templates';
has hint        => <<EOF;

See 'APPLICATION generateapp help GENERATOR' for more information on a specific
generator.
EOF
has message    => sub { shift->extract_usage . "\nGenerators:\n" };
has namespaces => sub { ['Wansanpo::Command::generateapp'] };

sub help { shift->run(@_) }

1;

=encoding utf8

=head1 NAME

Wansanpo::Command::generateapp - Generator command

=head1 SYNOPSIS

  Usage: APPLICATION generateapp GENERATOR [OPTIONS]

    carton exec -- script/wansanpo generateapp upload_sample

=cut
