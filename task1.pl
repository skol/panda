#!/usr/bin/perl -w
use strict;
use warnings;

use lib "./lib";
use Benchmark qw(cmpthese);

use Code::Task1;

my @tests = ([10000, 1000], [100, 10000], [1000, 100000], [1000, 1000000]);

for my $arr (@tests) {
    print("\n---\n");
    print("$arr->[0] и $arr->[1]\n");
    print("---\n");
    my %big_hash = map { $_ => int(rand($arr->[0])) } 1..$arr->[1];
    cmpthese(-5, {
        compact_each_loop => sub { compact_each_loop(\%big_hash) },
        compact_for_loop => sub { compact_for_loop(\%big_hash) },
        compact_reverse_twice => sub { compact_reverse_twice(\%big_hash) },
        compact_grep => sub { compact_grep(\%big_hash) },
        compact_map => sub { compact_map(\%big_hash) },
        compact_reverse_twice_pre => sub { compact_reverse_twice_pre(\%big_hash) },
        compact_reverse_inplace => sub { compact_reverse_inplace(\%big_hash) },
    });
}
