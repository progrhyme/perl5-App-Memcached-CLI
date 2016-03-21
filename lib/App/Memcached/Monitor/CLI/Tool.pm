package App::Memcached::Monitor::CLI::Tool;

use strict;
use warnings;
use 5.008_001;

use Class::Accessor::Lite (
    ro => [qw/addr mode/],
);

use Getopt::Long qw(:config posix_default no_ignore_case no_ignore_case_always);
use IO::Socket::INET;

use App::Memcached::Monitor::Util ':all';

use version; our $VERSION = 'v0.0.1';

sub new {
}

sub parse_args {
    my @args = @_;

    my %params; # will be passed to new()
    if ( looks_like_addr($args[0]) ) {
        $params{addr} = shift @args;
    }

    Getopt::Long::GetOptionsFromArray(
        \@args, \%params, 'addr|a=s',
        'mode|m=s', 'from|f=s', 'debug|d'
    );
}

1;
__END__

=encoding utf-8

=head1 NAME

App::Memcached::Monitor::CLI::Tool - It's new $module

=head1 SYNOPSIS

    use App::Memcached::Monitor::CLI::Tool;

=head1 DESCRIPTION

App::Memcached::Monitor::CLI::Tool is ...

=head1 LICENSE

Copyright (C) YASUTAKE Kiyoshi.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

YASUTAKE Kiyoshi E<lt>yasutake.kiyoshi@gmail.comE<gt>

=cut

