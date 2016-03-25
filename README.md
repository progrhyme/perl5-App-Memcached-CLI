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

- **stats|\\s** _REGEXP_

    Shows general statistics of memcached server by `stats` command.
    You can filter the parameters of stats by optional _REGEXP_ argument.

    Comes from _memcached/memcached-tool_.

- **settings|config|\\c** _REGEXP_

    Shows memcached server settings by `stats settings` command.
    You can filter the parameters of stats by optional _REGEXP_ argument.

    Comes from _memcached/memcached-tool_, too.

- **cachedump|dump|\\cd** _CLASS_ \[_NUMBER_\]

    Shows keys and sizes and expiration times of some items in specified slab _CLASS_.

    You can specify _NUMBER_ of items to show.
    Without _NUMBER_ option, shows 20 items only by default.

- **detaildump|\\dd**

    Reports statistics about data access using KEY prefix. The default separator for
    prefix is ':'.

    If you have not enabled reporting at Memcached start-up, you can enable it by
    command `detail on`.

    See man **memcached(1)** for details.

- **detail** _MODE_

    Enables or disables stats collection for `stats detail dump` reporting.

    _MODE_ should be either "on" or "off" to enable or to disable.

- **get** _KEY1_ \[_KEY2_ ...\]

    Gets items in memcached by specified _KEYs_ and shows their data.

- **gets** _KEY1_ \[_KEY2_ ...\]

    Gets items with _CAS_ data in memcached by specified _KEYs_ and shows their
    data.

- **set** _KEY_ _VALUE_ \[_EXPIRE_ \[_FLAGS_\]\]

    Stores data into memcached by specified _KEY_, _VALUE_ and optional _EXPIRE_
    and _FLAGS_.

- **add** _KEY_ _VALUE_ \[_EXPIRE_ \[_FLAGS_\]\]

    Stores data into memcached by specified _KEY_, _VALUE_ and optional _EXPIRE_
    and _FLAGS_ only when there is NO data with the same _KEY_ in the server.

- **replace** _KEY_ _VALUE_ \[_EXPIRE_ \[_FLAGS_\]\]

    Stores data into memcached by specified _KEY_, _VALUE_ and optional _EXPIRE_
    and _FLAGS_ only when there IS data with the same _KEY_ in the server.

- **append** _KEY_ _VALUE_

    Appends _VALUE_ after existing data in memcached which has specified _KEY_.

- **prepend** _KEY_ _VALUE_

    Puts _VALUE_ before existing data in memcached which has specified _KEY_.

- **cas** _KEY_ _VALUE_ _CAS_ \[_EXPIRE_ \[_FLAGS_\]\]

    Stores data into memcached by specified _KEY_, _VALUE_ and optional _EXPIRE_
    and _FLAGS_ only when _CAS_ of data is not changed from specified _CAS_ value.

- **touch** _KEY_ _EXPIRE_

    Update data expiration time with specified _KEY_ and _EXPIRE_.

- **delete** _KEY_

    Deletes one item in memcached by specified _KEY_.

- **flush\_all|flush** \[_DELAY_\]

    Invalidates all data in memcached by `flush_all` command.

    With _DELAY_ option, invalidation is delayed for specified seconds.

    See official documentation of _memcached_ for details.

- **version**

    Shows memcahed server version.

- **quit|exit|\\q**

    Exits program in interactive mode.

- **help|\\h** \[_COMMAND_\]

    Shows available _COMMANDs_ and summary of their usage.

    With optional _COMMAND_ argument, shows detailed information of it.

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
