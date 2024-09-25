#!/usr/bin/perl
use strict;
use warnings;





# 示例用法
my @array1 = (1, 2, 3);
my @array2 = (4, 5, 6);
my $sum = add(3, \@array1, \@array2);
my $dot = dot(3, \@array1, \@array2);


print "$sum\n";  # 输出: 5 7 9 = 21
print "$dot\n";  # 输出: 4 10 18 = 32


sub dot {#(length,arry1,arry2)
    my ($n, $arr1_ref, $arr2_ref) = @_;
    my $result = 0;

    for (my $i = 0; $i < $n; $i++) {
        $result = $result + $arr1_ref->[$i] * $arr2_ref->[$i];
    }

    return $result;
}


sub add {#(length,arry1,arry2)
    my ($n, $arr1_ref, $arr2_ref) = @_;
    my $result = 0;

    for (my $i = 0; $i < $n; $i++) {
        $result = $result + $arr1_ref->[$i] + $arr2_ref->[$i];
    }

    return $result;
}

# 定义变量
my $name = "Alice";
my $age = 30;

# 定义数组
my @fruits = ("Apple", "Banana", "Cherry");

# 打印变量
print "Name: $name\n";
print "Age: $age\n";

# 打印数组
print "Fruits: @fruits\n";
print "Perl version: ", $], "\n";


