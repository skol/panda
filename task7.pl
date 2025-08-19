#!/usr/bin/perl -w
use strict;
use warnings;
use feature 'say';

use lib "./lib";
use Code::Task7;

get_http("ya.ru", "/search/", {text => "rust"});

get_http_async("ya.ru", "/search/", {text => "rust"}, 120);
