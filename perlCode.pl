#!/usr/bin/perl
use strict;
use warnings;

my $points_Num = 5;
my $r_equ = 1.5;

my $iniRange = 0.8 * $r_equ * $points_Num **(1/3);

my @points_List = (rand(), rand(), rand(),);

@points_List = map { ($_ * 2 - 1 )* $iniRange / 1.8 } @points_List;

my @random_point = @points_List;
my $mid_dis

for my $i(1..$points_Num-1){
    @random_point = (rand(), rand(), rand(),);
    @random_point = map { ($_ * 2 - 1 )* $iniRange } @random_point;
    

}




sub norm {
    my ($array_ref) = @_;
    my $result = 0;

    my @array_f = @$array_ref;

    for my $num (@array_f) {
        $result += $num**2;
    }

    return sqrt($result);
}

sub add {
    my ($arr1_ref, $arr2_ref) = @_;
    my $result = 0;

    my @arr1_f = @$arr1_ref;
    my @arr2_f = @$arr2_ref;

    for my $i (0 .. $#arr1_f) {
        $result += $arr1_f[$i] + $arr2_f[$i];
    }

    return $result;
}

sub dot {
    my ($arr1_ref, $arr2_ref) = @_;
    my $result = 0;

    my @arr1_f = @$arr1_ref;
    my @arr2_f = @$arr2_ref;

    for my $i (0 .. $#arr1_f) {
        $result += $arr1_f[$i] * $arr2_f[$i];
    }

    return $result;
}

