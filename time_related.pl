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

my $logFileName = strftime("%m.%d-%H_%M_%S", localtime);
$logFileName = "${logFileName}_log.txt";
$logFileName = $floder . $logFileName;
open my $logFile, '>', $logFileName or die "filed to open '$logFileName': $!";

my $elapsed = tv_interval($start);

print $logFile "it takes us: $elapsed seconds\n";

close $logFile;

print "creat and write log.txt finished!\n";
