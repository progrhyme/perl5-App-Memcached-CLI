package App::Memcached::Monitor::CLI::Tool;

use strict;
use warnings;
use 5.008_001;

use Getopt::Long qw(:config posix_default no_ignore_case no_ignore_case_always);
use IO::Socket::INET;
use List::Util qw(first);

use App::Memcached::Monitor;
use App::Memcached::Monitor::DataSource;
use App::Memcached::Monitor::Util ':all';

use version; our $VERSION = 'v0.0.1';

my @MODES        = qw(display dump stats settings sizes help man);
my $DEFAULT_MODE = $MODES[0];

sub new {
    my $class  = shift;
    my %params = @_;
    $params{ds}
        = App::Memcached::Monitor::DataSource->connect(
            $params{addr}, timeout => $params{timeout}
        );

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
        \my %opts, 'addr|a=s', 'mode|m=s', 'timeout|t=i',
        'debug|d', 'help|h', 'man',
    ) or return +{};
    warn "Unevaluated args remain: @ARGV" if (@ARGV);

    if (defined $opts{man}) {
        $params{mode} = 'man';
    }
    if (defined $opts{help}) {
        $params{mode} = 'help';
    }
    if (defined $opts{debug}) {
        $App::Memcached::Monitor::DEBUG = 1;
    }

    %params = (
        addr    => create_addr($params{addr} || $opts{addr}),
        mode    => $params{mode} || $opts{mode} || $DEFAULT_MODE,
        timeout => $opts{timeout},
        debug   => $opts{debug},
    );
    unless (first { $_ eq $params{mode} } @MODES) {
        warn "Invalid mode! $params{mode}";
        delete $params{mode};
    }

    return \%params;
}

sub run {
    my $self = shift;
    debug "[start] $self->{mode} $self->{addr}";
    my $method = $self->{mode};
    unless ($self->$method) {
        warn "Command '$self->{mode}' seems failed. Set '--debug' option if you want to see debug logs.";
        exit 1;
    }
    debug "[end] $self->{mode} $self->{addr}";
}

sub display {
    my $self = shift;
    my $response = $self->{ds}->query('stats items');
    $response = $self->{ds}->query('stats slabs');
    print $response;
    return;
}

sub stats {
    my $self = shift;
    my $response = $self->{ds}->query('stats');
    my @raw_stats = split(m/[\r\n]+/, $response);
    my %stats;
    for my $line (@raw_stats) {
        if ($line =~ m/^STAT\s+(\S*)\s+(.*)/) {
            $stats{$1} = $2;
        }
    }
    print "# stats - $self->{addr}\n";
    printf "#%23s  %16s\n", 'Field', 'Value';
    for my $field (sort {$a cmp $b} (keys %stats)) {
        printf ("%24s  %16s\n", $field, $stats{$field});
    }
    return 1;
}

sub settings {
    my $self = shift;
    my $response = $self->{ds}->query('stats settings');
    my @raw_stats = split(m/[\r\n]+/, $response);
    my %stats;
    for my $line (@raw_stats) {
        if ($line =~ m/^STAT\s+(\S*)\s+(.*)/) {
            $stats{$1} = $2;
        }
    }
    print "# stats settings - $self->{addr}\n";
    printf "#%23s  %16s\n", 'Field', 'Value';
    for my $field (sort {$a cmp $b} (keys %stats)) {
        printf ("%24s  %16s\n", $field, $stats{$field});
    }
    return 1;
}

sub dump {
    my $self = shift;
    my $response = $self->{ds}->query('stats items');
    # And query 'stats cachedump' for each slab
    print $response;
    return;
}

sub sizes {
    my $self = shift;
    my $response = $self->{ds}->query('stats sizes');
    my @raw_stats = split(m/[\r\n]+/, $response);
    my %stats;
    for my $line (@raw_stats) {
        if ($line =~ m/^STAT\s+(\S*)\s+(.*)/) {
            $stats{$1} = $2;
        }
    }
    print "# stats sizes - $self->{addr}\n";
    printf "#%17s  %12s\n", 'Size', 'Count';
    for my $field (sort {$a cmp $b} (keys %stats)) {
        printf ("%18s  %12s\n", $field, $stats{$field});
    }
    return 1;
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

