package App::Memcached::CLI::Constants;

use strict;
use warnings;
use 5.008_001;

use Exporter 'import';

our @EXPORT_OK = qw(
    DEFAULT_PORT
    DEFAULT_ADDR
);
our %EXPORT_TAGS = (all => \@EXPORT_OK);

use version; our $VERSION = 'v0.0.1';

my $DEFAULT_PORT = 11211;

sub DEFAULT_PORT { $DEFAULT_PORT }
sub DEFAULT_ADDR { '127.0.0.1:' . $DEFAULT_PORT }

1;
__END__

=encoding utf-8

=head1 NAME

App::Memcached::CLI::Constants - It's new $module

=head1 SYNOPSIS

    use App::Memcached::CLI::Constants;

=head1 DESCRIPTION

App::Memcached::CLI::Constants is ...

=head1 LICENSE

Copyright (C) YASUTAKE Kiyoshi.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

YASUTAKE Kiyoshi E<lt>yasutake.kiyoshi@gmail.comE<gt>

=cut

