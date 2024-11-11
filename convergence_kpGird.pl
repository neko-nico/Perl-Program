#!perl

use strict;
use warnings;
use Getopt::Long;
use MaterialsScript qw(:all);


#--> Import .xsd File
my $doc = $Documents{"Atoms_3_castep.xsd"};

print "import finish, start caculation.\n";

my $scfCon = 2e-006;
my ($energy, $kpGrid);

my $filename = 'C:\Users\m\Documents\Materials Studio Projects\castep_Files\Documents\kpGrid.csv';
open my $pfile, '>', $filename or die "filed to open '$filename': $!";

for (my $i = 1; $i <= 3; $i+=1) {
    
    eval {
        $kpGrid = $i;
        print "kpGrid = ",$i,"\n";
        print "CASTEP is runnign~~~\n";
        my $results = Modules->CASTEP->Energy->Run($doc, Settings(
            UseCustomEnergyCutoff => 'Yes', 
            EnergyCutoff => 326.5, 
            SCFConvergence => $scfCon, 
            KPointDerivation => 'CustomGrid',
            ParameterA => $kpGrid,
            ParameterB => $kpGrid,
            ParameterC => $kpGrid,
        ));
        print "CASTEP finish!!\n";

        $energy = $results->TotalEnergy;
        print "we get the energy:", $energy, "\n";
        print $pfile "$kpGrid,$energy\n";

    };

    if ($@) {
        print "Time->$i, failed! $@\n";
        next;
    }
}

close $pfile;

print "All finish!\n";




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

    return ($mid_dis_f, $pointi_f);
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
        print join(" ", @array_f[$i .. $i + 2]), "\n" if $i + 2 < @array_f;
    }
}




