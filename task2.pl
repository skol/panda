#!/usr/bin/perl -w
use strict;
use warnings;
use feature 'say';

use lib "./lib";
use Code::Task2;

my $user = Code::Task2->new(
    name => 'Igor', 
    age => 50,
    login => 'skol',
    password => 'abbat');

say $user->get_name;
$user->set_name('Egor');
say $user->get_name;

eval { $user->set_age(30) };
say "Ошибка: $@" if $@;  # Упадёт, т.к. age — 'ro'

say $user->get_login();
$user->set_password('gatekeeper');
eval { $user->get_password() };
say "Ошибка: $@" if $@;  # Упадёт, т.к. password — 'wo'
