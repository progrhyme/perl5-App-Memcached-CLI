package App::Memcached::Monitor::CLI::Tool;

use strict;
use warnings;
use 5.008_001;

use Class::Accessor::Lite (
    ro => [qw/addr mode/],
);

use Getopt::Long qw(:config posix_default no_ignore_case no_ignore_case_always);
use IO::Socket::INET;
use List::Util qw(first);

use App::Memcached::Monitor::Util ':all';

use version; our $VERSION = 'v0.0.1';

my @MODES        = qw(display dump stats settings sizes help man);
my $DEFAULT_MODE = $MODES[0];

sub new {
    my $class  = shift;
    my %params = @_;

    bless \%params, $class;
}

sub parse_args {
    my $class = shift;

    my %params; # will be passed to new()
    if (defined $ARGV[0] and looks_like_addr($ARGV[0])) {
        $params{addr} = shift @ARGV;
    }
    if (defined $ARGV[0] and first { $_ eq $ARGV[0] } @MODES) {
        $params{mode} = shift @ARGV;
    }

    GetOptions(
        \my %opts, 'addr|a=s', 'mode|m=s', 'debug|d', 'help|h', 'man'
    ) or return +{};

    if (defined $opts{man}) {
        $params{mode} = 'man';
    }
    if (defined $opts{help}) {
        $params{mode} = 'help';
    }

    %params = (
        addr  => create_addr($params{addr} || $opts{addr}),
        mode  => $params{mode} || $opts{mode} || $DEFAULT_MODE,
        debug => $opts{mode},
    );

    return \%params;
}

sub run {
    my $self = shift;
    print "[START] $self->{mode}\n";
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

