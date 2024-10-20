 #!perl

use strict;
use warnings;
use Getopt::Long;
use MaterialsScript qw(:all);


my $points_Num = 3;
my $r_equ = 1.5;

my $iniRange = 0.8 * $r_equ * $points_Num **(1/3);

my @points_List = (rand(), rand(), rand(),);

@points_List = map { ($_ * 2 - 1 )* $iniRange / 1.8 } @points_List;

my @random_point = @points_List;
my $mid_dis;

for my $i(1..$points_Num-1){
    @random_point = (rand(), rand(), rand(),);
    @random_point = map { ($_ * 2 - 1 )* $iniRange } @random_point;
    $mid_dis = (distance(\@random_point,\@points_List))[0];

    while ( $mid_dis < $r_equ || norm(\@random_point) > $iniRange) {
        @random_point = (rand(), rand(), rand(),);
        @random_point = map { ($_ * 2 - 1 )* $iniRange } @random_point;
        $mid_dis = (distance(\@random_point,\@points_List))[0];
        #print "Too close, restart!\n";
    }
    push @points_List, @random_point;
}

@points_List = map { $_ + $iniRange } @points_List;

print "pointsList:\n";
psList(\@points_List);

my $doc = $Documents{"Atoms_3Dmol.xsd"};
my $atoms = $doc -> Atoms;

for (my $i = 0; $i < @$atoms; $i++) {
    my $atom = @$atoms[$i];
    $atom->XYZ = Point(X => $points_List[3*$i],
    		       Y => $points_List[3*$i+1],
    		       Z => $points_List[3*$i+2]);
    #print 'point: ',$i," is changed\n";
}

$doc->Save();

	
my $results = Modules->DMol3->Energy->Run($doc, Settings(
	Quality => 'Medium', 
	AtomCutoff => 3.3, 
	CalculateForces => 'Yes'));



my $res_Atoms = $results->Structure->Atoms;

foreach my $resatom (@$res_Atoms){
	my $force = $resatom->Force;
	print "Force of Atom: \nx-> ",$force->X,
			     "\ny-> ",$force->Y,
			     "\nz-> ",$force->Z,"\n";
}







#my $results = Modules->CASTEP->Energy->Run($system, Settings(
#	SCFConvergence => 1e-006, 
#	CalculateStress => 'Yes', 
#	Quality => 'Fine', 
#	# PropertiesKPointQuality => 'Fine'
#));









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

