[![Build Status](https://travis-ci.org/key-amb/perl5-App-Memcached-CLI.svg?branch=master)](https://travis-ci.org/key-amb/perl5-App-Memcached-CLI)
# NAME

**memcached-cli** - Interactive/Batch CLI for Memcached

# SYNOPSIS

Run an interactive CLI:

```
memcached-cli <host[:port] | /path/to/socket> [options]

# Without 1st arg, connects 127.0.0.1:11211 by default
memcached-cli [options]
# You can provide <addr> by option style
memcached-cli --addr|-a <host[:port] | /path/to/socket> [options]
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
