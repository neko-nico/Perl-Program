#!perl

use strict;
use Getopt::Long;
use MaterialsScript qw(:all);
use Storable qw(store);
use Storable qw(retrieve);
use Time::HiRes qw(gettimeofday tv_interval);
use POSIX qw(strftime);


my $start = [gettimeofday];

my $floder = 'C:/Users/Neko/Documents/Materials Studio Projects/castep_Files/Documents/';

my $timeStr = strftime("%Y%m%d-%H_%M_%S", localtime);
my $logFileName = "MinSearch/log_${timeStr}.txt";
$logFileName = $floder . $logFileName;
open my $logFile, '>', $logFileName or die "filed to open '$logFileName': $!";

my $elapsed = tv_interval($start);

print $logFile "it takes us: $elapsed seconds\n";

close $logFile;
