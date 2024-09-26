#!/usr/bin/perl
use strict;
use warnings;


my @vector = 0..2;
# @vector = map { $_ + 0.1} @vector;

my @list = 0..2;

print join(", ", @vector), "\n";
print join(", ", @list), "\n";

my ($dis, $pid) = distence(\@vector,\@list);
print $dis**2, ', ', $pid,"\n";

my $first = (distence(\@vector,\@list))[0];
print $first**2,"\n";


#三个一行进行打印
for (my $i = 0; $i < @points_List; $i += 3) {
    print join(" ", @points_List[$i .. $i + 2]), "\n"# if $i + 2 < @points_List;
}


sub distence {#(vector,pList)
    my ($vector_ref, $pList_ref) = @_;
    my @vector_f = @$vector_ref;
    my @pList_f = @$pList_ref;

    my $pointi_f = 0;
    my @mid_vec = add( \@vector_f, [ @pList_f[0..2] ],1);
    my $mid_dis = norm(\@mid_vec);

    if ( $mid_dis == 0 ){
        $pointi_f = 1;
        @mid_vec = add( \@vector_f, [ @pList_f[3..5] ],1);
    }

    my $dis = 0;

    for (my $i = 3; $i < $#pList_f; $i += 3){
        @mid_vec = add( \@vector_f, [ @pList_f[$i..$i+2] ],1);
        $dis = norm(\@mid_vec);

        if ($mid_dis > $dis && $dis != 0) {
            $mid_dis = $dis;
            $pointi_f = $i/3;
        }
    }

    return ($mid_dis, $pointi_f);  # 返回多个值
}



sub norm {  # (array)
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

sub dot {#(arry1,arry2)
    my ($arr1_ref, $arr2_ref) = @_;
    my @arr1_f = @$arr1_ref;
    my @arr2_f = @$arr2_ref;

    my $result = 0;

    for my $i (0 .. $#arr1_f) {
        $result += $arr1_f[$i] * $arr2_f[$i];
    }

    return $result;
}





