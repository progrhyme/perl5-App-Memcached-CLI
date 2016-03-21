package App::Memcached::Monitor::Util;

use strict;
use warnings;
use 5.008_001;

use Exporter 'import';

our @EXPORT_OK = qw(
    looks_like_addr
);
our %EXPORT_TAGS = (all => \@EXPORT_OK);

use version; our $VERSION = 'v0.0.1';

sub looks_like_addr {
    my $string = shift;
    return;
}

1;
__END__

=encoding utf-8

=head1 NAME

App::Memcached::Monitor::Util - It's new $module

=head1 SYNOPSIS

    use App::Memcached::Monitor::Util;

=head1 DESCRIPTION

App::Memcached::Monitor::Util is ...

=head1 LICENSE

Copyright (C) YASUTAKE Kiyoshi.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

YASUTAKE Kiyoshi E<lt>yasutake.kiyoshi@gmail.comE<gt>

=cut



