#!/usr/bin/perl -w
use strict;
use warnings;

use lib "./lib";
use Benchmark qw(cmpthese);

use Code::Task9;

my @sorted_array = (1..1000000);
cmpthese(-1, {
    linear   => sub { linear_search(\@sorted_array, 999999) },
    binary   => sub { binary_search(\@sorted_array, 999999) },
    golden   => sub { golden_search(\@sorted_array, 999999) },
});
