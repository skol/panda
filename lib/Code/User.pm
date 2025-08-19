package Code::User;
use lib "./lib";
use Code::Accessor;
use parent 'Code::Accessor';

Code::Accessor->import(
    name => 'rw',
    age  => 'ro'
);

sub new {
    my ($class, %args) = @_;
    bless \%args, $class;
}

1;