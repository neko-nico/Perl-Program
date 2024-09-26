#!/usr/bin/perl
use strict;
use warnings;

my $points_Num = 100;
my $r_equ = 1.5;

my $iniRange = 0.8 * $r_equ * $points_Num **(1/3);

my @points_List = (rand(), rand(), rand(),);

@points_List = map { ($_ * 2 - 1 )* $iniRange / 1.8 } @points_List;

my @random_point = @points_List;
my $mid_dis;

for my $i(1..$points_Num-1){
    @random_point = (rand(), rand(), rand(),);
    @random_point = map { ($_ * 2 - 1 )* $iniRange } @random_point;
    $mid_dis = (distence(\@random_point,\@points_List))[0];

    while ( $mid_dis < $r_equ || norm(\@random_point) > $iniRange) {
        @random_point = (rand(), rand(), rand(),);
        @random_point = map { ($_ * 2 - 1 )* $iniRange } @random_point;
        $mid_dis = (distence(\@random_point,\@points_List))[0];
        print "Too close, restart!\n";
    }
    push @points_List, @random_point;
}









sub distence {#(vector,pList)
    my ($vector_ref, $pList_ref) = @_;
    my @vector_f = @$vector_ref;
    my @pList_f = @$pList_ref;

    my $pointi_f = 0;
    my @mid_vec_f = add( \@vector_f, [ @pList_f[0..2] ],1);
    my $mid_dis_f = norm(\@mid_vec_f);

    if ( $mid_dis_f == 0 ){
        $pointi_f = 1;
        @mid_vec_f = add( \@vector_f, [ @pList_f[3..5] ],1);
    }

    my $dis = 0;

    for (my $i = 3; $i < $#pList_f; $i += 3){
        @mid_vec_f = add( \@vector_f, [ @pList_f[$i..$i+2] ],1);
        $dis = norm(\@mid_vec_f);

        if ($mid_dis_f > $dis && $dis != 0) {
            $mid_dis_f = $dis;
            $pointi_f = $i/3;
        }
    }

    return ($mid_dis_f, $pointi_f);  # 返回多个值
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

