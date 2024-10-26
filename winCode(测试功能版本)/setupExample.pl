#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
use MaterialsScript qw(:all);
use Math::Trig;

my $doc = MaterialsScript::Documents->New("Atoms.xsd");

my $pointsNum = 10;
my $n = $pointsNum*3;
my $r0Parm = 1.539;
my $iniRange = $r0Parm* (0.5+ (3* $pointsNum/ (4*pi*1.4142))**(1/3));

print $pointsNum, ', ', $n, ', ', $r0Parm, ', ', $iniRange, ',\n';

for (my $i = 0; $i < $n; $i++) {

    my $r = rand($r0Parm);
    my $theta = rand(pi);
    my $phi = rand(2*pi);
    
    my $x = $r * sin($theta) * cos($phi);
    my $y = $r * sin($theta) * sin($phi);
    my $z = $r * cos($theta);
    
    $doc->CreateAtom("C", Point(X => $x, Y => $y, Z => $z));
    
}

$doc->Save();
