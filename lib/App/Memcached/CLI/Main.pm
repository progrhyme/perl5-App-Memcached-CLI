package App::Memcached::CLI::Main;

use strict;
use warnings;
use 5.008_001;

use Carp;
use Getopt::Long qw(:config posix_default no_ignore_case no_ignore_case_always);
use IO::Socket::INET;
use List::Util qw(first);

use App::Memcached::CLI;
use App::Memcached::CLI::DataSource;
use App::Memcached::CLI::Util ':all';

use version; our $VERSION = 'v0.1.0';

my %COMMAND2ALIASES = (
    help      => ['\h'],
    quit      => [qw(\q exit)],
    display   => [qw(\d)],
    stats     => [qw(\s)],
    settings  => [qw(\c config)],
    cachedump => [qw(\cd dump)],
);
my %COMMAND_OF;
while (my ($cmd, $aliases) = each %COMMAND2ALIASES) {
    $COMMAND_OF{$cmd} = $cmd;
    $COMMAND_OF{$_}   = $cmd for @$aliases;
}

my $DEFAULT_CACHEDUMP_SIZE = 20;

sub new {
    my $class  = shift;
    my %params = @_;

    eval {
        $params{ds}
            = App::Memcached::CLI::DataSource->connect(
                $params{addr}, timeout => $params{timeout}
            );
    };
    if ($@) {
        warn "Can't connect to Memcached server! Addr=$params{addr}";
        debug "ERROR: " . $@;
        return;
    }

    bless \%params, $class;
}

sub parse_args {
    my $class = shift;

    my %params; # will be passed to new()
    if (defined $ARGV[0] and looks_like_addr($ARGV[0])) {
        $params{addr} = shift @ARGV;
    }
    GetOptions(
        \my %opts, 'addr|a=s', 'timeout|t=i',
        'debug|d', 'help|h', 'man',
    ) or return +{};
    warn "Unevaluated args remain: @ARGV" if (@ARGV);

    if (defined $opts{debug}) {
        $App::Memcached::CLI::DEBUG = 1;
    }

    %params = (%opts, %params);
    $params{addr} = create_addr($params{addr});

    return \%params;
}

sub run {
    my $self = shift;
    debug "[start] $self->{addr}";
    my $isa_tty = -t STDIN && (-t STDOUT || !(-f STDOUT || -c STDOUT));
    unless ($isa_tty) {
        croak "TTY Not Found! Quit.";
    }
    my $exit_loop = 0;
    local $SIG{INT} = local $SIG{QUIT} = sub {
        $exit_loop = 1;
        warn "Caught INT or QUIT. Exiting...";
    };
    print "Type '\\h' or 'help' to show help.\n\n";
    while (! $exit_loop) {
        my ($command, @args) = $self->prompt;
        next unless $command;
        if ($command eq 'quit') {
            $exit_loop = 1;
            next;
        }

        my $ret = $self->$command(@args);
        unless ($ret) {
            print "Command seems failed. Type \\h $command for help.\n\n";
        }
    }
    debug "[end] $self->{addr}";
}

sub prompt {
    my $self = shift;

    local $| = 1;
    local $\;

    print "memcached\@$self->{addr}> ";
    my $input = <STDIN>;
    chomp $input;
    return unless $input;

    my ($_command, @args) = split(m/\s+/, $input);
    my $command = $COMMAND_OF{$_command};
    print "Unknown command - $input\n" unless $command;

    return $command, @args;
}

sub help {
    my $self    = shift;
    my $command = shift || q{};

    my @command_info = (
        +{
            command => 'help',
            summary => 'Show help (this)',
        },
        +{
            command => 'quit',
            summary => 'Exit',
        },
        +{
            command => 'display',
            summary => 'Display slabs info',
        },
        +{
            command => 'stats',
            summary => 'Show stats',
        },
        +{
            command => 'settings',
            summary => 'Show settings',
        },
        +{
            command => 'cachedump',
            summary => 'Show cachedump of specified slab',
            description => <<'EODESC',
Usage:
    > cachedump <CLASS> <NUMBER>
    > cachedump 1 10
    > cachedump 3     # default <NUMBER>
EODESC
        },
    );
    my $body   = q{};
    my $space  = ' ' x 4;
    if (my $function = $COMMAND_OF{$command}) {
        my $aliases = join(q{, }, _sorted_aliases_of($function));
        my $info = (grep { $_->{command} eq $function } @command_info)[0];
        $body .= sprintf qq{\n[Command "%s"]\n\n}, $command;
        $body .= "Summary:\n";
        $body .= sprintf "%s%s\n\n", $space, $info->{summary};
        $body .= "Aliases:\n";
        $body .= sprintf "%s%s\n\n", $space, $aliases;
        if ($info->{description}) {
            $body .= $info->{description};
            $body .= "\n";
        }
        print $body;
        return 1;
    } elsif ($command) {
        $body .= "Unknown command: $command\n";
    }
    $body .= "\n[Available Commands]\n";
    for my $info (@command_info) {
        my $cmd = $info->{command};
        my $commands = join(q{, }, _sorted_aliases_of($cmd));
        $body .= sprintf "%-20s%s%s\n", $commands, $space, $info->{summary};
    }
    $body .= "\nType \\h <command> for each.\n\n";
    print $body;
    return 1;
}

sub _sorted_aliases_of {
    my $command = shift;
    my @aliases = @{$COMMAND2ALIASES{$command}};
    return (shift @aliases, $command, @aliases);
}

sub cachedump {
    my $self  = shift;
    my $class = shift;
    my $num   = shift || $DEFAULT_CACHEDUMP_SIZE;

    unless ($class) {
        print "No slab class specified.\n";
        return;
    }
    my $response = $self->{ds}->query("stats cachedump $class $num");
    print "$_\n" for @$response;
    return 1;
}

sub display {
    my $self = shift;

    my %stats;
    my $max = 1;

    my $resp_items = $self->{ds}->query('stats items');
    for my $line (@$resp_items) {
        if ($line =~ m/^STAT items:(\d+):(\w+) (\d+)/) {
            $stats{$1}{$2} = $3;
        }
    }

    my $resp_slabs = $self->{ds}->query('stats slabs');
    for my $line (@$resp_slabs) {
        if ($line =~ m/^STAT (\d+):(\w+) (\d+)/) {
            $stats{$1}{$2} = $3;
            $max = $1;
        }
    }

    print "  #  Item_Size  Max_age   Pages   Count   Full?  Evicted Evict_Time OOM\n";
    for my $class (1..$max) {
        my $slab = $stats{$class};
        next unless $slab->{total_pages};

        my $size
            = $slab->{chunk_size} < 1024 ? "$slab->{chunk_size}B"
            : sprintf("%.1fK", $slab->{chunk_size} / 1024.0) ;

        my $full = ($slab->{free_chunks_end} == 0) ? 'yes' : 'no';
        printf(
            "%3d %8s %9ds %7d %7d %7s %8d %8d %4d\n",
            $class, $size, $slab->{age} || 0, $slab->{total_pages},
            $slab->{number} || 0, $full, $slab->{evicted} || 0,
            $slab->{evicted_time} || 0, $slab->{outofmemory} || 0,
        );
    }

    return 1;
}

sub stats {
    my $self = shift;
    my $response = $self->{ds}->query('stats');
    my %stats;
    for my $line (@$response) {
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
    my %stats;
    for my $line (@$response) {
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

1;
__END__

=encoding utf-8

=head1 NAME

App::Memcached::CLI::Main - It's new $module

=head1 SYNOPSIS

    use App::Memcached::CLI::Main;

=head1 DESCRIPTION

App::Memcached::CLI::Main is ...

=head1 LICENSE

Copyright (C) YASUTAKE Kiyoshi.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

YASUTAKE Kiyoshi E<lt>yasutake.kiyoshi@gmail.comE<gt>

=cut

