package Code::DealingCards;
use strict;
use warnings;
 
use Exporter qw(import);
 
our @EXPORT = qw(dealing_cards card_info);

our @VALUE2STR = (
    'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine', 'ten', 'jack', 'queen', 'king', 'ace',
);

our @SUIT2STR = (
    'crosses', 'spades', 'diamonds', 'hearts',
);

our @COLOR2STR = (
    'black', 'red',
);

sub shuffle_array {
    my $arr = shift;
    my $n = $#$arr;

    for (my $i = $#$arr; $i > 0; $i--) {
        my $j = int(rand($i + 1));
        @$arr[$i, $j] = @$arr[$j, $i];
    }
}

sub shuffling_deck_cards {
    my @cards = 0..51;
    shuffle_array(\@cards);
    return \@cards;
}

sub card_info {
    my $idx = shift;
    return undef if $idx < 0 or $idx > 51;
    my $value = ($idx % 13) - 1;        # массив считается с 0
    my $suit = int($idx / 13);
    my $color = [0, 0, 1, 1]->[$suit];
    my @result = ($COLOR2STR[$color], $SUIT2STR[$suit], $VALUE2STR[$value], $idx);
    return \@result;
}

sub dealing_cards {
    my %result = (
        1 => [],
        2 => [],
        3 => [],
        4 => [],
        5 => [],
        6 => [],
        7 => [],
        8 => [],
        9 => [],
        five => [],
        deck => [],
    );
    my $deck = shuffling_deck_cards();
    for my $j (1..2) {
        for my $k (1..9) {
            push @{$result{$k}}, pop @$deck;
        }
    }
    @{$result{five}} = @{$deck}[-5..-1];
    $result{deck} = $deck;
    return \%result;
}

1;
