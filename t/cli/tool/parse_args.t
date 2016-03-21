use strict;
use warnings;
use 5.008_001;

use Test::More 0.98;

use App::Memcached::Monitor::CLI::Tool;

my $Class = 'App::Memcached::Monitor::CLI::Tool';

subtest 'With no argument' => sub {
    my $default = 'display';
    local @ARGV = ();
    my $parsed = $Class->parse_args;
    is($parsed->{mode}, $default, "default $default");
};

subtest 'With normal single mode' => sub {
    my @pattern = qw/dump/;
    local @ARGV = @pattern;
    my $parsed = $Class->parse_args;
    is($parsed->{mode}, $pattern[0], $pattern[0]);
};

subtest 'With help/-h/--help' => sub {
    my @patterns = ([qw/help/], [qw/-h/], [qw/--help/]);
    for my $ptn (@patterns) {
        local @ARGV = @$ptn;
        my $parsed = $Class->parse_args;
        is($parsed->{mode}, 'help', $ptn->[0]);
    }
};

subtest 'With man/--man' => sub {
    my @patterns = ([qw/man/], [qw/--man/]);
    for my $ptn (@patterns) {
        local @ARGV = @$ptn;
        my $parsed = $Class->parse_args;
        is($parsed->{mode}, 'man', $ptn->[0]);
    }
};

subtest '--help/--man overwrites other modes' => sub {
    my @patterns = ([qw/display --help help/], [qw/stats --man man/]);
    for my $ptn (@patterns) {
        local @ARGV = @$ptn[0,1];
        my $parsed = $Class->parse_args;
        is($parsed->{mode}, $ptn->[2], "$ptn->[0] is overwritten by $ptn->[1]");
    }
};

done_testing;

