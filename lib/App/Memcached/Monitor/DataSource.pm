package App::Memcached::Monitor::DataSource;

use strict;
use warnings;
use 5.008_001;

use Carp;
use IO::Socket;

use App::Memcached::Monitor::Util qw(is_unixsocket debug);

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
            Timeout  => $opts{timeout} || 5,
        );
    }->();
    confess "Can't connect to $addr" unless $socket;

    return $class->new(socket => $socket);
}

sub query {
    my $self    = shift;
    my @queries = @_;
    my $response = q{};
    $response .= $self->_query_one($_) for @queries;
    return $response;
}

sub _query_one {
    my $self  = shift;
    my $query = shift;

    my $socket = $self->{socket};
    print $socket "$query\r\n";

    my $body = q{};
    while (<$socket>) {
        last if m/^END/;
        confess $_ if m/^SERVER_ERROR/;
        $body .= $_;
    }

    return $body;
}

sub DESTROY {
    my $self = shift;
    if ($self->{socket}) { $self->{socket}->close; }
}

1;
__END__

=encoding utf-8

=head1 NAME

App::Memcached::Monitor::DataSource - It's new $module

=head1 SYNOPSIS

    use App::Memcached::Monitor::DataSource;

=head1 DESCRIPTION

App::Memcached::Monitor::DataSource is ...

=head1 LICENSE

Copyright (C) YASUTAKE Kiyoshi.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

YASUTAKE Kiyoshi E<lt>yasutake.kiyoshi@gmail.comE<gt>

=cut

