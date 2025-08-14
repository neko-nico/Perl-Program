 #不再需要的样例代码


my $func = 0;

print "正常循环访问\n"
;for (my $i = 0; $i < 4; $i++) {
    print "i = ",$i,", and func = ";
    $func = $i**2;
    print $func,",\n"
;}


if ((1 >= 2)) {
    print '1>=2';
} else {
    print '<';
}


# my @array_add = add($arrays_copies[1],$arrays_copies[2]);
# print "@array_add\n";  # 输出: 4 5 6


##取数值的符号
my $a_sign = 3;
my $b_sign = 5;
my $result_sign = $a_sign *2 ** sign($a_sign*$b_sign);

print $result_sign,"\n";

##测试检测最近原子
my @vector = 0..2;
# @vector = map { $_ + 0.1} @vector;

my @list = 0..11;

print join(", ", @vector), "\n";
print join(", ", @list), "\n";

my ($dis, $pid) = distance(\@vector,\@list);
print $dis**2, ', ', $pid,"\n";

my $first = (distance(\@vector,\@list))[0];
print $first**2,"\n";


##三个一行进行打印
for (my $i = 0; $i < @points_List; $i += 3) {
    print join(" ", @points_List[$i .. $i + 2]), "\n"# if $i + 2 < @points_List;
}

###数组相加 相乘 模长
# 示例用法
my $iniRange = 10;

my @array1 = ($iniRange*rand(), $iniRange*rand(), $iniRange*rand(), $iniRange*rand(),);
print join(", ", @array1), "\n";

my @array2 = (4, 5, 6, 7);
print join(", ", @array2), "\n";

my @sum = add(\@array1, \@array2,1);
my $dot = dot(\@array1, \@array2);
my $norm = norm(\@array1);

print "@sum\n";  # 输出: 5 7 9 = 21
print "$dot\n";  # 输出: 4 10 18 = 32
print $norm**2,"\n";  # 输出: 1 4 9 = 14


#实现数组中所有元素乘以一个数
my @array1 = (rand(), rand(), rand());  # 生成三个随机数
my $multiplier = 10;

# 使用 map 进行元素乘法
my @result = map { $_ * $multiplier } @array1;

print "@result\n";  # 输出乘以 10 的所有元素


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
#print "Perl version: ", $], "\n";





#各类函数调用

sub get_EngAndGrad{#(points_list)
    my ($plist_f) = @_;
    my $length = scalar @$plist_f;
    my @result = random_array($length, 3);

    return (rand()*10,@result);
}

sub random_array {
    my ($length, $range) = @_;
    my @random_array_f;

    for (my $i = 0; $i < $length; $i++) {
        push @random_array_f, (2* rand()-1)* $range;
    }

    return @random_array_f;
}


sub distance {#(vector,pList)
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

sub sign {
    my ($value_f) = @_;
    return ($value_f > 0) ? 1 : ($value_f < 0) ? -1 : 0;
}

sub psList {
    my ($array_ref) = @_;
    my @array_f = @$array_ref;

    for (my $i = 0; $i < @array_f; $i += 3) {
        print $logFile join(" ", @array_f[$i .. $i + 2]), "\n" if $i + 2 < @array_f;
    }
}




##计算能量和梯度的实际代码

# my $doc = $Documents{"Atoms_3.xsd"};
# my $atoms = $doc -> DisplayRange -> Atoms;
# caculateForceCastep(\@points_List, "dmol");

# sub caculateForceCastep{ #doc, $atoms
#     my ($pList_ref, $module_f) = @_;
#     my @pList_f = @$pList_ref;
#     my @fList_f = (0) x @$pList_f;

#     if (scalar @$atoms == scalar @pList_f) {
#         print "Same lenth, No Problem~\n";
#     } else{
#         print "Length is error!!\n"
#     }

#     for (my $i = 0; $i < @$atoms; $i++) {
#         my $atom = @$atoms[$i];
#         $atom->XYZ = Point(X => $pList_f[3*$i],
#                        Y=> $pList_f[3*$i+1],
#                        Z => $pList_f[3*$i+2]);
#         #print 'point: ',$i," is changed\n";
#     }

#     $doc->Save();

#     if ($module_f eq "castep") {
#         print "Using Castep Modules~\n"

#         my $results = Modules->CASTEP->Energy->Run($doc, Settings(
#             SCFConvergence => 1e-005, 
#             Quality => 'Coarse', 
#             # PropertiesKPointQuality => 'Coarse',
#         ));
#         print "Castep finish!\n"

#     } elsif ($module_f eq "dmol") {
#         print "Using DMol Modules~\n"

#         my $results = Modules->DMol3->Energy->Run($doc, Settings(
#             CalculateForces => 'Yes',
#             Quality => 'Medium', 
#             AtomCutoff => 3.3,
#         ));
#         print "MMol finish!\n"

#     }else {
#         print "?what?,check you input!\n"
#     }

#     my $result_Atoms = $results->Structure->DisplayRange->Atoms;

#     for (my $i = 0; $i < @$result_Atoms; $i++) {
#         my $eachAtom = @$result_Atoms[$i];
#         my $forceOfAtom = $eachAtom->Force;
#         $fList_f[ 3*$i ] = $forceOfAtom->X;
#         $fList_f[3*$i+1] = $forceOfAtom->Y;
#         $fList_f[3*$i+2] = $forceOfAtom->Z;
#     }
#     my $result_energy = $results->TotalEnergy;

#     return ($result_energy, @fList_f);
# }
