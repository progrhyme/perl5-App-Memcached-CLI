[![Build Status](https://travis-ci.org/key-amb/perl5-App-Memcached-CLI.svg?branch=master)](https://travis-ci.org/key-amb/perl5-App-Memcached-CLI)
# NAME

**memcached-cli** - Interactive/Batch CLI for Memcached

# SYNOPSIS

Run an interactive CLI:

```
memcached-cli <HOST[:PORT] | /path/to/socket> [OPTIONS]
memcached-cli --addr|-a <HOST[:PORT] | /path/to/socket> [OPTIONS]
memcached-cli [OPTIONS]  # Connect to 127.0.0.1:11211
```

These above turns into interactive mode like below:

```
memcached@SERVER:PORT>
memcached@SERVER:PORT> \h    # show help
memcached@SERVER:PORT> \d    # display slabs info
```

Run as batch script:

```
memcached-cli [options] <command> [<args>]
```

Show Help/Manual:

```
# For general usage
memcached-cli -h|--help
memcached-cli --man

# For available commands
memcached-cli help
memcached-cli help <command>
```

# DESCRIPTION

This script runs an interactive CLI or batch utility for Memcached.

In interactive mode, it connects to a specified Memcached server and
interactively executes each command you run.

In batch mode, you can execute any command which you can do in interactive mode.

# COMMANDS

NOTE:

A couple of features of following commands derives from
[memcached/memcached-tool](https://github.com/memcached/memcached/blob/master/scripts/memcached-tool)

- **display|\\d**

    Displays slabs statistics.

    This command comes from _memcached/memcached-tool_.

- **stats|\\s**

    Shows general statistics of memcached server by `stats` command.

    Just like _memcached/memcached-tool_ does.

- **settings|config|\\c**

    Shows memcached server settings by `stats settings` command.

    Just like _memcached/memcached-tool_ does.

- **cachedump|dump|\\cd** CLASS \[NUMBER\]

    Shows keys and sizes and expiration times of some items in specified slab CLASS.

    You can specify NUMBER of items to show.
    Without NUMBER option, shows 20 items only by default.

- **detaildump|\\dd**

    Reports statistics about data access using KEY prefix. The default separator for
    prefix is ':'.

    If you have not enabled reporting at Memcached start-up, you can enable it by
    command `detail on`.

    See man **memcached(1)** for details.

- **detail** MODE

    Enables or disables stats collection for `stats detail dump` reporting.

    MODE should be either "on" or "off" to enable or to disable.

- **get** KEY

    Gets one item in memcached by specified KEY and shows its data.

- **set** KEY VALUE \[EXPIRE \[FLAGS\]\]

    Stores data into memcached by specified KEY, VALUE and optional EXPIRE and FLAGS.

- **delete** KEY

    Deletes one item in memcached by specified KEY.

- **flush\_all|flush** \[DELAY\]

    Invalidates all data in memcached by `flush_all` command.

    With DELAY option, invalidation is delayed for specified seconds.

    See official documentation of _memcached_ for details.

- **version**

    Shows memcahed server version.

- **quit|exit|\\q**

    Exits program in interactive mode.

- **help|\\h** \[COMMAND\]

    Shows available COMMANDs and summary of their usage.

    With optional COMMAND argument, shows detailed information of it.

# OPTIONS

- **-t|--timeout=Int**

    Sets connection timeout. Default is 1 seconds.

- **-d|--debug**

    Shows debug logs.

# SEE ALSO

[App::Memcached::CLI::Main](https://metacpan.org/pod/App::Memcached::CLI::Main),
**memcached(1)**,
[http://www.memcached.org/](http://www.memcached.org/)

# AUTHORS

YASUTAKE Kiyoshi <yasutake.kiyoshi@gmail.com>

# LICENSE

Copyright (C) 2015 YASUTAKE Kiyoshi.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.  That means either (a) the GNU General Public
License or (b) the Artistic License.
