package Code::Accessor;
use strict;
use warnings;
use Scalar::Util 'blessed';

eval {
    require Class::XSAccessor;
    Class::XSAccessor->import;
    1;
} or warn "Class::XSAccessor не установлен. Используется чистый Perl.\n";

sub import {
    my ($class, %args) = @_;
    my $caller = caller(0);

    no strict 'refs';
    for my $field (keys %args) {
        my $type = $args{$field} || 'rw';  # 'ro', 'wo', 'rw'

        # Геттер
        if ($type =~ /r/) {
            *{"${caller}::get_$field"} = sub { $_[0]->{$field} };
        }

        # Сеттер
        if ($type =~ /w/) {
            *{"${caller}::set_$field"} = sub {
                die "Объект неизменяем" if blessed($_[0]) && $_[0]->{_is_frozen};
                $_[0]->{$field} = $_[1];
                return $_[0];  # Для цепочки вызовов
            };
        }
    }
}

1;
