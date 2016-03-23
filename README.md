# NAME

__memcached-cli__ - Interactive CLI for Memcached

# SYNOPSIS

Run an interactive CLI:

    memcached-cli <host[:port] | /path/to/socket> [options]

    # Without 1st arg, connects 127.0.0.1:11211 by default
    memcached-cli [options]
    # You can provide <addr> by option style
    memcached-cli --addr|-a <host[:port] | /path/to/socket> [options]

These above turns into interactive mode like below:

    memcached@SERVER:PORT>
    memcached@SERVER:PORT> \h    # show help
    memcached@SERVER:PORT> \d    # display slabs info

Show Help/Manual:

    memcached-cli -h|--help
    memcached-cli --man

# DESCRIPTION

This script provides interactive CLI for Memcached.

It connects to a specified Memcached server and interactively executes each
command you run.

# OPTIONS

- __-t|--timeout=Int__

    Sets connection timeout. Default is 5 seconds.

- __-d|--debug__

    Shows debug logs.

# SEE ALSO

[App::Memcached::CLI](https://metacpan.org/pod/App::Memcached::CLI),
__memcached(1)__,
[http://www.memcached.org/](http://www.memcached.org/)

# AUTHORS

YASUTAKE Kiyoshi <yasutake.kiyoshi@gmail.com>

# LICENSE

Copyright (C) 2015 YASUTAKE Kiyoshi.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.  That means either (a) the GNU General Public
License or (b) the Artistic License.
