#!/usr/bin/perl
use strict;
use warnings;



#生成随机数组
my @randList = random_array(15, 10);  # 生成长度为5，范围[-10, 10]的随机数组
psList(\@randList);

#返回能量和梯度测试
my ($energy_mid, @gr_mid) = get_EngAndGrad(\@randList);
print 'energy:', $energy_mid, ', gr:', "\n";

psList(\@gr_mid);

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

sub psList {
    my ($array_ref) = @_;
    my @array_f = @$array_ref;

    for (my $i = 0; $i < @array_f; $i += 3) {
        print join(" ", @array_f[$i .. $i + 2]), "\n" if $i + 2 < @array_f;
    }
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





