#不再需要的样例代码



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



