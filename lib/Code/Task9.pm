package Code::Task9;
use strict;
use warnings;

use constant PHI => 1.61803398875;
 
use Exporter qw(import);
 
our @EXPORT = qw(linear_search binary_search golden_search);

sub linear_search {
    my ($arr, $target) = @_;
    my $high = $#$arr;

    return undef if $high == 0;
    return 0 if $target <= $arr->[0];
    return $high if $arr->[$high] <= $target;
    
    for my $i (0..($high - 1)) {
        if (($arr->[$i] <= $target) && ($target <= $arr->[$i+1])) {
            return (abs($target - $arr->[$i]) <= abs($arr->[$i+1] - $target)) ? $i : $i+1;
        }
    }
}

sub binary_search {
    my ($arr, $target) = @_;
    my ($low, $high) = (0, $#$arr);
    my $mid = int(($low + $high) / 2);

    return undef if $high == 0;
    return 0 if $target <= $arr->[0];
    return $high if $arr->[$high] <= $target;
    
    while ($low <= $high) {
        return $mid if $arr->[$mid] == $target;
        last if(($low == $high) or ($low + 1 == $high));

        if ($arr->[$mid] < $target) {
            $low = $mid;
        } else {
            $high = $mid;
        }
        $mid = int(($low + $high) / 2);
    }
    return (abs($arr->[$low] - $target) <= abs($arr->[$high] - $target)) ? $low : $high;
}

sub golden_search {
    my ($arr, $target) = @_;
    my ($low, $high) = (0, $#$arr);
    my $mid = int(($low + $high) / PHI);

    return undef if $high == 0;
    return 0 if $target <= $arr->[0];
    return $high if $arr->[$high] <= $target;

    while ($low <= $high) {
        return $mid if $arr->[$mid] == $target;
        last if(($low == $high) or ($low + 1 == $high));

        if ($arr->[$mid] < $target) {
            $low = $mid;
        } else {
            $high = $mid;
        }
        $mid = $high - int(($high - $low) / PHI);
    }
    return (abs($arr->[$low] - $target) <= abs($arr->[$high] - $target)) ? $low : $high;
}

1;
