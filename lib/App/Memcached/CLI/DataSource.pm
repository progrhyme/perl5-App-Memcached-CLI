package App::Memcached::CLI::DataSource;

use strict;
use warnings;
use 5.008_001;

use Carp;
use IO::Socket;

use App::Memcached::CLI::Util qw(is_unixsocket debug);

sub new {
    my $class = shift;
    my %args  = @_;
    bless \%args, $class;
}

sub connect {
    my $class = shift;
    my $addr  = shift;
    my %opts  = @_;

    my $socket = sub {
        return IO::Socket::UNIX->new(Peer => $addr) if is_unixsocket($addr);
        return IO::Socket::INET->new(
            PeerAddr => $addr,
            Proto    => 'tcp',
            Timeout  => $opts{timeout} || 1,
        );
    }->();
    confess "Can't connect to $addr" unless $socket;

    return $class->new(socket => $socket);
}

sub get {
    my $self = shift;
    my $key  = shift;

    my $socket = $self->{socket};
    print $socket "get $key\r\n";

    my %data = (key => $key);
    my $response = <$socket>;
    if ($response =~ m/^VALUE \S+ (\d+) (\d+)/) {
        $data{flags}  = $1;
        $data{length} = $2;
        read $socket, $response, $data{length};
        $data{value} = $response;

        while ($response !~ m/^END/) { $response = $self->_readline; }
    } elsif ($response =~ m/^END/) {
        # not found
    } else {
        warn "Unknown response for KEY '$key'. '$response'";
    }

    return \%data;
}

sub query {
    my $self  = shift;
    my $query = shift;
    my $response = eval {
        return $self->_query($query);
    };
    if ($@) {
        confess "Failed to query! query: $query ERROR: " . $@;
    }
    return $response;
}

sub _query {
    my $self  = shift;
    my $query = shift;

    my $socket = $self->{socket};
    print $socket "$query\r\n";

    my @response;
    while (1) {
        my $line = $self->_readline;
        $line =~ s/[\r\n]+$//;
        last if ($line =~ m/^(OK|END)/);
        die $line if ($line =~ m/^(CLIENT|SERVER_)?ERROR/);
        push @response, $line;
    }

    return \@response;
}

sub _readline {
    my $self   = shift;
    my $socket = $self->{socket};
    local $SIG{ALRM} = sub { die 'Timed out to Read Socket.' };
    alarm 3;
    my $line = <$socket>;
    alarm 0;
    return $line;
}

sub DESTROY {
    my $self = shift;
    if ($self->{socket}) { $self->{socket}->close; }
}

1;
__END__

=encoding utf-8

=head1 NAME

App::Memcached::CLI::DataSource - Data Access Interface of Memcached server

=head1 SYNOPSIS

    use App::Memcached::CLI::DataSource;
    my $ds = App::Memcached::CLI::DataSource->connect(
            $params{addr}, timeout => $params{timeout}
        );
    my $stats = $ds->query('stats');

=head1 DESCRIPTION

This provides data access interface for Memcached server.

=head1 LICENSE

Copyright (C) YASUTAKE Kiyoshi.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

YASUTAKE Kiyoshi E<lt>yasutake.kiyoshi@gmail.comE<gt>

=cut

