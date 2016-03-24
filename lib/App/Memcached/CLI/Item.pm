package App::Memcached::CLI::Item;

use strict;
use warnings;
use 5.008_001;

use App::Memcached::CLI::Util ':all';

use version; our $VERSION = 'v0.3.0';

my $DISPLAY_DATA_LENGTH = 320;

sub new {
    my $class = shift;
    my %data  = @_;
    bless \%data, $class;
}

sub find_by_get {
    my $class = shift;
    my $key   = shift;
    my $ds    = shift;

    my $data = $ds->get($key);
    return unless $data->{value};

    bless $data, $class;
}

sub output {
    my $self = shift;
    my $space = q{ } x 4;
    my %method = (value => 'disp_value');
    for my $key (qw/key value flags length/) {
        my $value = $self->{$key};
        if (my $_method = $method{$key}) {
            $value = $self->$_method;
        }
        printf "%s%6s:%s%s\n", $space, $key, $space, $value;
    }
}

sub disp_value {
    my $self = shift;
    $self->{disp_value} ||= sub {
        my $text = $self->value_text;
        return $text if (length $text <= $DISPLAY_DATA_LENGTH);

        my $length = length $text;
        my $result = substr($text, 0, $DISPLAY_DATA_LENGTH - 1);
        $result .= '...(the rest is skipped)';
        return $result;
    }->();
    return $self->{disp_value};
}

sub value_text {
    my $self = shift;
    $self->{value_text} ||= sub {
        if ($self->{value} !~ m/^[\x21-\x7e\s]/) {
            return '(Not ASCII)';
        }
        return $self->{value};
    }->();
    return $self->{value_text};
}

1;
__END__

=encoding utf-8

=head1 NAME

App::Memcached::CLI::Item - Object module of Memcached data item

=head1 SYNOPSIS

    use App::Memcached::CLI::Item;
    my $item = App::Memcached::CLI::Item->get($key, $self->{ds});
    print $item->output;

=head1 DESCRIPTION

This package acts as object of Memcached data item.

=head1 LICENSE

Copyright (C) YASUTAKE Kiyoshi.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

YASUTAKE Kiyoshi E<lt>yasutake.kiyoshi@gmail.comE<gt>

=cut

