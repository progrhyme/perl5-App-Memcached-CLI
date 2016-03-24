package App::Memcached::CLI::Help;

use strict;
use warnings;
use 5.008_001;

use version; our $VERSION = 'v0.6.1';

our @COMMANDS_INFO = (
    +{
        command => 'help',
        summary => 'Show help (this)',
    },
    +{
        command => 'version',
        summary => 'Show server version',
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
        description => <<'EODESC',
Usage:
    > stats [<REGEXP>]
    > stats            # show all stats
    > stats (hit|miss) # filter by REGEXP
EODESC
    },
    +{
        command => 'settings',
        summary => 'Show settings',
        description => <<'EODESC',
Usage:
    > settings [<REGEXP>]
    > settings             # show all stats
    > settings ^(lru|slab) # filter by REGEXP
EODESC
    },
    +{
        command => 'cachedump',
        summary => 'Show cachedump of specified slab',
        description => <<'EODESC',
Usage:
    > cachedump <CLASS> [<NUMBER>]
    > cachedump 1 10
    > cachedump 3     # show default number of items
EODESC
    },
    +{
        command => 'detaildump',
        summary => 'Show detail dump',
        description => <<'EODESC',
Description:
    Report statistics about data access using KEY prefix. The default separator
    for prefix is ':'.
    If you have not enabled reporting at Memcached start-up, run "detail on".
    See man memcached(1) for details.
EODESC
    },
    +{
        command => 'detail',
        summary => 'Enable/Disable detail dump',
        description => <<'EODESC',
Usage:
    > detail on
    > detail off

Description:
    See "\h detaildump"
EODESC
    },
    +{
        command => 'get',
        summary => 'Get data by KEY',
        description => <<'EODESC',
Usage:
    > get <KEY>
EODESC
    },
    +{
        command => 'set',
        summary => 'Set data by KEY VALUE',
        description => <<'EODESC',
Usage:
    > set <KEY> <VALUE> [<EXPIRE> [<FLAGS>]]
    > set mykey1 MyValue1
    > set mykey2 MyValue2 0     # Never expires. Default
    > set mykey3 MyValue3 120 1
EODESC
    },
    +{
        command => 'add',
        summary => 'Add data by KEY VALUE',
        description => <<'EODESC',
Description:
    Store data if server has no data with the KEY.

Usage:
    > add <KEY> <VALUE> [<EXPIRE> [<FLAGS>]]
    > add mykey1 MyValue1
    > add mykey2 MyValue2 0     # Never expires. Default
    > add mykey3 MyValue3 120 1
EODESC
    },
    +{
        command => 'replace',
        summary => 'Replace data by KEY VALUE',
        description => <<'EODESC',
Description:
    Overwrite data if server has data with the KEY.

Usage:
    > replace <KEY> <VALUE> [<EXPIRE> [<FLAGS>]]
    > replace mykey1 MyValue1
    > replace mykey2 MyValue2 0     # Never expires. Default
    > replace mykey3 MyValue3 120 1
EODESC
    },
    +{
        command => 'append',
        summary => 'Append data by KEY VALUE',
        description => <<'EODESC',
Description:
    Append VALUE after existing data which has specified KEY.

Usage:
    > append <KEY> <VALUE>
    > append mykey MySuffix
EODESC
    },
    +{
        command => 'prepend',
        summary => 'Prepend data by KEY VALUE',
        description => <<'EODESC',
Description:
    Put VALUE before existing data which has specified KEY.

Usage:
    > prepend <KEY> <VALUE>
    > prepend mykey MyPrefix
EODESC
    },
    +{
        command => 'delete',
        summary => 'Delete data by KEY',
        description => <<'EODESC',
Usage:
    > delete <KEY>
EODESC
    },
    +{
        command => 'flush_all',
        summary => 'Invalidate whole data',
        description => <<'EODESC',
Usage:
    > flush_all [<DELAY>]
    > flush_all           # Invalidate immediately
    > flush_all 60        # Invalidate after 60 seconds
EODESC
    },
);

1;
__END__

=encoding utf-8

=head1 NAME

App::Memcached::CLI::Help - Utility to show commands help

=head1 SYNOPSIS

    use App::Memcached::CLI::Help;
    my @command_info = @App::Memcached::CLI::Help::COMMANDS_INFO;

=head1 DESCRIPTION

This package provides utility for commands help.

=head1 LICENSE

Copyright (C) YASUTAKE Kiyoshi.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

YASUTAKE Kiyoshi E<lt>yasutake.kiyoshi@gmail.comE<gt>

=cut

