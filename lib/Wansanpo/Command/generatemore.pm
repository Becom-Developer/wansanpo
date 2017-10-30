package Wansanpo::Command::generatemore;
use Mojo::Base 'Mojolicious::Commands';

has description => 'Generate files and directories from your own templates';
has hint        => <<EOF;

See 'APPLICATION generatemore help GENERATOR' for more information on a specific
generator.
EOF
has message    => sub { shift->extract_usage . "\nGenerators:\n" };
has namespaces => sub { ['Wansanpo::Command::generatemore'] };

sub help { shift->run(@_) }

1;

=encoding utf8

=head1 NAME

Wansanpo::Command::generatemore - Generator command

=head1 SYNOPSIS

  Usage: APPLICATION generatemore GENERATOR [OPTIONS]

    carton exec -- script/wansanpo generatemore upload_sample

=cut
