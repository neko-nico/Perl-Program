#!/usr/bin/perl
use strict;
use warnings;



# 示例用法
my $iniRange = 10;

my @array1 = ($iniRange*rand(), $iniRange*rand(), $iniRange*rand(), $iniRange*rand(),);
print join(", ", @array1), "\n";

my @array2 = (4, 5, 6, 7);
print join(", ", @array2), "\n";

my $sum = add(\@array1, \@array2);
my $dot = dot(\@array1, \@array2);
my $norm = norm(\@array1);

print "$sum\n";  # 输出: 5 7 9 = 21
print "$dot\n";  # 输出: 4 10 18 = 32
print $norm**2,"\n";  # 输出: 1 4 9 = 14


sub distence{
    

}


sub norm {  # (array)
    my ($array_ref) = @_;
    my $result = 0;

    my @array_f = @$array_ref;

    for my $num (@array_f) {
        $result += $num**2;
    }

    return sqrt($result);
}

sub add {#(arry1,arry2)
    my ($arr1_ref, $arr2_ref) = @_;
    my $result = 0;

    my @arr1_f = @$arr1_ref;
    my @arr2_f = @$arr2_ref;

    for my $i (0 .. $#arr1_f) {
        $result += $arr1_f[$i] + $arr2_f[$i];
    }

    return $result;
}

sub dot {#(arry1,arry2)
    my ($arr1_ref, $arr2_ref) = @_;
    my $result = 0;

    my @arr1_f = @$arr1_ref;
    my @arr2_f = @$arr2_ref;

    for my $i (0 .. $#arr1_f) {
        $result += $arr1_f[$i] * $arr2_f[$i];
    }

    return $result;
}





