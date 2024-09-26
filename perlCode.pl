#!/usr/bin/perl
use strict;
use warnings;

my $points_Num = 4;
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

# psList(\@points_List);

my ($energy_mid, @gr_mid) = get_EngAndGrad(\@points_List);
print "energy:\n", $energy_mid, ",\ngr:\n";
psList(\@gr_mid);

my $energy = $energy_mid;
my @gr = - @gr_mid;
my @dr = map { -$_ } @gr_mid;
#print 'gr_mid:', scalar(@gr_mid), ', dr:',scalar(@dr),"\n";

my $k = 0;
my $t = 1;
my @glist;
push @glist, [ @gr ];
my @dlist;
push @dlist, [ @dr ];
my @elist = ($energy);

my $h = norm(\@gr)/1000;
print 'first step:', $h, ".\n";
my @hlist = ($h);
my @section = (0);
my $nantest = 0;
my $maxMove = 0.1;

my $a_param = 0;
my $b_param = 0;
my $change = 0;
my $accu = 0.1;
my $ss = 0;
my $zz = 0;
my $ww = 0;

my $times = 0;
my $timeTotal = 0;
#my $notimes = 0;

my ($t1,$f1,$g1,$limit);

while (norm(\@gr) > 0.05 * sqrt($points_Num) && $times < 5 ) {
    $times ++;
    print "point:",$times,"\n";

    $t1 = 0;
    ($energy_mid, @gr_mid) = get_EngAndGrad(\@points_List);
    $f1 = $energy_mid;

    $g1 = - dot(\@gr_mid,\@dr);
    printf("t1:%.4f, f1:%.4f, g1:%.4f\n", $t1, $f1, $g1);

    $limit = 0;


}



sub get_EngAndGrad{#(points_list)
    my ($plist_f) = @_;
    my $length = scalar @$plist_f;  # 获取数组长度
    my @result = random_array($length, 3);

    return (rand()*10,@result);
}

sub random_array {
    my ($length, $range) = @_;
    my @random_array;

    for (my $i = 0; $i < $length; $i++) {
        push @random_array, (2* rand()-1)* $range;
    }

    return @random_array;
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
    my @array_f = @$array_ref;

    my $result = 0;

    for my $num (@array_f) {
        $result += $num**2;
    }

    return sqrt($result);
}

sub add {
    my ($arr1_ref, $arr2_ref,$control_f) = @_;
    my @arr1_f = @$arr1_ref;
    my @arr2_f = @$arr2_ref;

    my @result;

    for my $i (0 .. $#arr1_f) {
        $result[$i] = $arr1_f[$i] + $arr2_f[$i]* (-1)**$control_f;
    }

    return @result;
}

sub dot {
    my ($arr1_ref, $arr2_ref) = @_;
    my @arr1_f = @$arr1_ref;
    my @arr2_f = @$arr2_ref;

    my $result = 0;

    for my $i (0 .. $#arr1_f) {
        $result += $arr1_f[$i] * $arr2_f[$i];
    }

    return $result;
}

sub random_array {
    my ($length, $range) = @_;
    my @random_array;

    for (my $i = 0; $i < $length; $i++) {
        push @random_array, (2* rand()-1)* $range;
    }

    return @random_array;
}

sub psList {
    my ($array_ref) = @_;
    my @array_f = @$array_ref;

    for (my $i = 0; $i < @array_f; $i += 3) {
        print join(" ", @array_f[$i .. $i + 2]), "\n" if $i + 2 < @array_f;
    }
}

