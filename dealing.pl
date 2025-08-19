#!/usr/bin/perl -w
use strict;
use warnings;

use lib "./lib";

use Code::DealingCards;
use Data::Dumper;

my $r = dealing_cards();
my @me =(card_info($r->{5}->[0]), card_info($r->{5}->[1]));
print Dumper(\@me)."\n";
