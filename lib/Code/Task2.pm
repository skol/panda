package Code::Task2;
use lib "./lib";
use Code::User;
use parent 'Code::User';

Code::Accessor->import(
    login => 'rw',
    password  => 'wo'
);

1;
