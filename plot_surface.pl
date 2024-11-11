#!perl
#plot the energy surface in one dimension

use strict;
use warnings;
use Getopt::Long;
use MaterialsScript qw(:all);

#--> Creat Points List
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
        print "Too close, restart!\n";
    }
    push @points_List, @random_point;
}

@points_List = map { $_ + $iniRange } @points_List;

print "pointsList:\n";
psList(\@points_List);

#--> Import .xsd File
my $doc = $Documents{"Atoms_3_Dmol.xsd"};
my $atoms = $doc -> Atoms;
my $model_choose = "dmol";
#--

my ($energy_mid, @gr_mid) = caculateForce(\@points_List, $model_choose);

print "we get the intial energy:", $energy_mid,"\n","and the forceList:\n";
psList(\@gr_mid);

my $energy = $energy_mid;
my @gr = @gr_mid;
my @dr = map { -$_ } @gr;
#print 'gr_mid:', scalar(@gr_mid), ', dr:',scalar(@dr),"\n";

my $h = norm(\@gr)/1000000;
my @plist_hdr = map { $_ * $h } @dr;

my @elist = ($energy);
my @drgrList = (dot(\@gr,\@dr));

for (my $i = 0; $i < 5; $i++) {
    @points_List = add(\@points_List, \@plist_hdr, 0);
    ($energy_mid, @gr_mid) = caculateForce(\@points_List, $model_choose);

    push @elist, $energy_mid;
    push @drgrList, dot(\@gr_mid,\@dr);
}


#my @data_index = (1..@elist);
#save_two_arrays_to_csv(\@data_index, \@elist,
#                        'C:\Users\25592\Documents\Materials Studio Projects\castep_Files\Documents\elist.csv');
#save_two_arrays_to_csv(\@data_index, \@drgrList,
#                        'C:\Users\25592\Documents\Materials Studio Projects\castep_Files\Documents\drgrList.csv');

save_two_arrays_to_csv(\@elist, \@drgrList,
                        'C:\Users\m\Documents\Materials Studio Projects\castep_Files\Documents\Result.csv');
print "All finished!";



sub save_two_arrays_to_csv {
    my ($x_array_ref, $y_array_ref, $filename) = @_;

    open my $fh, '>', $filename or die "filed to open '$filename': $!";

    for (my $i = 0; $i < @$x_array_ref; $i++) {
        print $fh "$x_array_ref->[$i],$y_array_ref->[$i]\n";
    }

    close $fh;
}

sub caculateForce{ #doc, $atoms
    my ($pList_ref, $module_f) = @_;
    my @pList_f = @$pList_ref;
    my @fList_f = (0) x @pList_f;

    # if (3* scalar @$atoms == scalar @pList_f) {
    #     print "Same lenth, No Problem~\n";
    # } else{
    #     print "Length is error!!\n"
    # }

    for (my $i = 0; $i < @$atoms; $i++) {
        my $atom = @$atoms[$i];
        $atom->XYZ = Point(X => $pList_f[3*$i],
                       Y=> $pList_f[3*$i+1],
                       Z => $pList_f[3*$i+2]);
        #print 'point: ',$i," is changed\n";
    }

    $doc->Save();
    
    my $results;

    if ($module_f eq "castep") {
        print "Using Castep Modules~\n";

        $results = Modules->CASTEP->Energy->Run($doc, Settings(
            SCFConvergence => 1e-005, 
            Quality => 'Coarse', 
            # PropertiesKPointQuality => 'Coarse',
        ));
        print "Castep finish!\n";

    } elsif ($module_f eq "dmol") {
        print "Using DMol Modules~\n";

        $results = Modules->DMol3->Energy->Run($doc, Settings(
            CalculateForces => 'Yes',
            Quality => 'Medium', 
            AtomCutoff => 3.3,
        ));
        print "MMol finish!\n";

    }else {
        print "?what?,check you input!\n";
    }

    my $result_Atoms = $results->Structure->DisplayRange->Atoms;

    for (my $i = 0; $i < @$result_Atoms; $i++) {
        my $eachAtom = @$result_Atoms[$i];
        my $forceOfAtom = $eachAtom->Force;
        $fList_f[ 3*$i ] = $forceOfAtom->X;
        $fList_f[3*$i+1] = $forceOfAtom->Y;
        $fList_f[3*$i+2] = $forceOfAtom->Z;
    }
    my $result_energy = $results->TotalEnergy;

    # print "we get the energy:", $result_energy,"\n","and the forceList:\n";
    # psList(\@fList_f);

    return ($result_energy, map { -$_ } @fList_f);
}

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
        print join(" ", @array_f[$i .. $i + 2]), "\n" if $i + 2 < @array_f;
    }
}

