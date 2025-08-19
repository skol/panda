package Code::Task1;
use strict;
use warnings;
 
use Exporter qw(import);
 
our @EXPORT = qw(compact_each_loop compact_for_loop compact_reverse_twice compact_grep compact_map compact_reverse_inplace compact_reverse_twice_pre);

sub compact_each_loop {
    my $src = shift;
    my %seen;
    my %result;
    keys(%seen) = scalar(keys %$src);
    keys(%result) = scalar(keys %$src);
    while (my ($k, $v) = each %$src) {
        $result{$k} = $v unless $seen{$v}++;
    }
    return \%result;
}

sub compact_for_loop {
    my $src = shift;
    my %result;
    my %seen;
    keys(%seen) = scalar(keys %$src);
    keys(%result) = scalar(keys %$src);
    $seen{$src->{$_}}++ or $result{$_} = $src->{$_} for keys %$src;
    return \%result;
}

sub compact_reverse_twice {
    my $src = shift;
    my %result;
    my %reversed;
    %reversed = reverse(%$src);
    %result = reverse(%reversed);
    return \%result;
}

sub compact_reverse_twice_pre {
    my $src = shift;
    my %result;
    my %reversed;
    keys(%reversed) = scalar(keys %$src);
    %reversed = reverse(%$src);
    keys(%result) = scalar(keys %reversed);
    %result = reverse(%reversed);
    return \%result;
}


sub compact_grep {
    my $src = shift;
    my %result;
    my %tmp = ();
    keys(%tmp) = scalar(keys %$src);
    keys(%result) = scalar(keys %$src);
    %result = %$src{grep {$tmp{$src->{$_}}++ ? 0 : $_} keys %$src};
    return \%result;
}

sub compact_map {
    my $src = shift;
    my %result;
    my %tmp;
    keys(%tmp) = scalar(keys %$src);
    keys(%result) = scalar(keys %$src);
    map {$tmp{$src->{$_}}++ or $result{$_}=$src->{$_}} keys %$src;
    return \%result;
}

sub compact_reverse_inplace {
    my $src = shift;
    %$src = reverse reverse %$src;
    return $src;
}

1;
