#不再需要的样例代码


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



