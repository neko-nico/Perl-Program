#!perl

use strict;
use warnings;
use Getopt::Long;
use MaterialsScript qw(:all);
use Storable qw(store);
use Storable qw(retrieve);

my $floder = 'C:/Users/Neko/Documents/Materials Studio Projects/castep_Files/Documents/';

my $dateFileName = 'MinSearch/data_3.csv';
$dateFileName = $floder . $dateFileName;
open my $dateFile, '>', $dateFileName or die "filed to open '$dateFileName': $!";

print $dateFile "Energy, Gradient, Direction\n";

my $logFileName = 'MinSearch/log.txt';
$logFileName = $floder . $logFileName;
open my $logFile, '>', $logFileName or die "filed to open '$logFileName': $!";

my $variableFile = 'MinSearch/variables.dat';
$variableFile = $floder . $variableFile;

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
        print $logFile "Too close, restart!\n";
    }
    push @points_List, @random_point;
}

@points_List = map { $_ + $iniRange } @points_List;

print $logFile "pointsList:\n";
psList(\@points_List);

#--> Import .xsd File
my $doc = $Documents{"Atoms_3_Dmol.xsd"};
my $atoms = $doc -> Atoms;
my $model_choose = "dmol";
#--

my ($energy_mid, @gr_mid) = caculateForce(\@points_List, $model_choose);

print $logFile "we get the energy:", $energy_mid,"\n","and the forceList:\n";
psList(\@gr_mid);

my $energy = $energy_mid;
my @gr = @gr_mid;
my @dr = map { -$_ } @gr;
#print $logFile 'gr_mid:', scalar(@gr_mid), ', dr:',scalar(@dr),"\n";

my $k = 0;
my $t = 1;
my @glist;
push @glist, [ @gr ];
my @dlist;
push @dlist, [ @dr ];
my @elist = ($energy);

my $h = norm(\@gr)/100000;
print $logFile 'first step:', $h, ".\n";
my @hlist = ($h);

print $dateFile "$energy,$h\n";

my @section = (0);
my $nantest = 0;
my $maxMove = 0.1;

my $aa = 0;
my $bb = 0;
my $change = 0;
my $accu = 0.1;
my $ss = 0;
my $zz = 0;
my $ww = 0;

my $times = 0;
my $timeTotal = 0;
#my $notimes = 0;

my ($t1, $f1, $g1, $limit, @plist_mid,
    $t2, $f2, $g2, 
    $tNew, $fNew, $gNew,
    @move, @dr_mid, @glist_subtract, );

while (norm(\@gr) > 0.05 * sqrt($points_Num) && $times < 40 ) {

    $times++;
    print $logFile "point:",$times,"\n";

    $t1 = 0;
    ($energy_mid, @gr_mid) = caculateForce(\@points_List, $model_choose);
    $f1 = $energy_mid;
    $g1 = dot(\@gr_mid,\@dr);
    printf $logFile("t1:%.4f, f1:%.4f, g1:%.4f\n", $t1, $f1, $g1);

    $limit = 0;

    while ( (abs($g1) > $accu && $limit < 8 )|| $limit ==0 ) {
        $limit++;

        if ($g1 < 0) {
            $h = abs $h;
        } else {
            $h = - abs $h;
        }

        $t2 = $t1 + $h;
        @plist_mid = map { $_ * $t2 } @dr;
        @plist_mid = add(\@points_List, \@plist_mid, 0);

        ($energy_mid, @gr_mid) = caculateForce(\@plist_mid, $model_choose);
        $f2 = $energy_mid;
        $g2 = dot(\@gr_mid,\@dr);
        printf $logFile("t2:%.4f, f2:%.4f, g2:%.4f\n", $t2, $f2, $g2);

        if (abs($g2) < $accu) {
            $t1 = $t2 * 2** sign( $g1 * $g2 );
            $f1 = $f2;
            $g1 = $g2;
            print $logFile "finish, point satisfied.\n";
            printf $logFile("t1:%.4f, f1:%.4f, g1:%.4f\n", $t1, $f1, $g1);

            $timeTotal++;
            push @elist, $f1;
            $h = $t1;
            push @hlist, $h;
            print $dateFile "$f1,$h\n";
            last;
        }

        if ($g1 * $g2 < 0) {
            if ($h > 0) {
                $aa = $t1;
                $bb = $t2;
            } else {
                $aa = $t2;
                $bb = $t1;
                ($f1, $f2) = ($f2, $f1);
            }
            $ss = 3* ($f2 - $f1)/ ($bb - $aa);
            $zz = $ss - $g1 - $g2;
            $ww = sqrt($zz* $zz - $g1* $g2);

            $tNew = $t1 + ($bb - $aa)* (1 - ($g2 + $ww + $zz)/ ($g2 - $g1 + 2* $ww) );
            @plist_mid = map { $_ * $tNew } @dr;
            @plist_mid = add(\@points_List, \@plist_mid, 0);

            ($energy_mid, @gr_mid) = caculateForce(\@plist_mid, $model_choose);
            $fNew = $energy_mid;
            $gNew = dot(\@gr_mid,\@dr);

            if (($t1 < $tNew && $tNew < $t2) || ($t1 > $tNew && $tNew > $t2)) {

                if ( abs $gNew < abs $g1 ) {
                    if ( $gNew * $g1 > 0) {
                        $t1 = $tNew;
                        $f1 = $fNew;
                        $g1 = $gNew;
                        print $logFile "new Point!\n";

                    } else {
                        @dr = map { -$_ } @dr;
                        $t1 = - $tNew;
                        $f1 = $fNew;
                        $g1 = - $gNew;
                        print $logFile "new Point! ~ change Direction\n";
                    }
                }

                if ( abs($gNew) > $accu || $limit == 1 ) {
                    $h = $h / 6;
                    print $logFile "step too long!!\n";

                }

            } else {
                $h = $h / 4;
                $t1 = ($t1 + $t2)/ 2;
                @plist_mid = map { $_ * $t1 } @dr;
                @plist_mid = add(\@points_List, \@plist_mid, 0);

                ($energy_mid, @gr_mid) = caculateForce(\@plist_mid, $model_choose);
                $fNew = $energy_mid;
                $gNew = dot(\@gr_mid,\@dr);
                print $logFile "3rd interact error, take middle point\n"
            }

        } elsif (abs($g2) < 2 * abs($g1)) {
            $h = $h * 2;
            $t1 = $t2;
            $f1 = $f2;
            $g1 = $g2;
            print $logFile "forward, and step too short......\n";

        } else {
            $h = $h / 6;
            print $logFile "error in Grad, back.\n";

        }

        # print $logFile "energy:\n", $f1, ",\ngr:\n";
        # psList(\@gr);

        $timeTotal++;
        push @elist, $f1;
        push @hlist, $h;
        print $dateFile "$f1,$h\n";

    }
    print $logFile "Total circle times:", $timeTotal, "\n";

    if ($t1 == 0) {
        $t1 = $t1 + $h;
    }

    $h = $t1;
    $k++;
    push @section, $timeTotal;

    @move = map { $_ * $t1 } @dr;
    for (my $i = 0; $i < @move; $i++) {
        if (abs($move[$i]) > $maxMove) {
            $move[$i] = ($move[$i] > 0 ? 1 : -1) * $maxMove;
        }
    }
    @points_List = add(\@points_List, \@move, 0);
    # (_, @gr_mid) = caculateForce(\@points_List, $model_choose);
    # @gr = @gr_mid;
    
    ( $energy , @gr) = caculateForce(\@points_List, $model_choose);

    #ignore NaN test;

    push @glist,[ @gr ];

    if (abs( dot($glist[$k - 1], $glist[$k])) > 0.2* norm($glist[$k])**2 ||
        $k - $k >= 3* $points_Num - 1 )
    {
        $t = $k - 1;
        print $logFile "work!\n";
    }

    @glist_subtract = add($glist[$k], $glist[$k - 1], 1);
    @dr_mid = map { $_ * dot($glist[$k], \@glist_subtract)
                       / dot($dlist[$k - 1], \@glist_subtract)
                  } @{ $dlist[$k - 1] };
    @dr_mid = add(\@dr_mid, $glist[$k], 1);

    if ($k > $t + 1) {
        @glist_subtract = add ($glist[$t + 1], $glist[$t], 1);
        @dr_mid = add([ map { $_ * dot($glist[$k], \@glist_subtract)
                                 / dot($dlist[$t], \@glist_subtract)
                            } @{$dlist[$t]}], \@dr_mid, 0);
    }

    push @dlist, [@dr_mid];

    if ($k > $t + 1 &&
        -1.2* (norm($glist[$k]))**2 > dot($dlist[$k], $glist[$k]) ||
        dot($dlist[$k], $glist[$k]) > -0.8* (norm($glist[$k]))**2 ) 
    {
        $t = $k -1;
        @glist_subtract = add($glist[$k], $glist[$k - 1], 1);
        @dr_mid = add([ map { $_ * dot($glist[$k], \@glist_subtract)
                                 / dot($dlist[$k - 1], \@glist_subtract)
                            } @{$dlist[$k - 1]}], $glist[$k], 1);
        $dlist[$k] = [ @dr_mid ];
    }
    @dr = @dr_mid;

    #print $dateFile "@gr,@dr_mid\n";

}

($energy, @gr) = caculateForce(\@points_List, $model_choose);
print $logFile 'energy:',$energy,"\n";
psList(\@gr);

print $logFile "finish writing：data_x.csv\n";

my $dataStore_ref = {
    array1 => \@elist,
    array2 => \@glist,
    array3 => \@dlist,
    array4 => \@hlist,
    array5 => \@section,
    array6 => \@points_List,
};

store $dataStore_ref, $variableFile;
print  $logFile "store finish!\n";

close $dateFile;
close $logFile;



sub caculateForce{ #doc, $atoms
    my ($pList_ref, $module_f) = @_;
    my @pList_f = @$pList_ref;
    my @fList_f = (0) x @pList_f;

    # if (3* scalar @$atoms == scalar @pList_f) {
    #     print $logFile "Same lenth, No Problem~\n";
    # } else{
    #     print $logFile "Length is error!!\n"
    # }

    for (my $i = 0; $i < @$atoms; $i++) {
        my $atom = @$atoms[$i];
        $atom->XYZ = Point(X => $pList_f[3*$i],
                       Y=> $pList_f[3*$i+1],
                       Z => $pList_f[3*$i+2]);
        #print $logFile 'point: ',$i," is changed\n";
    }

    $doc->Save();
    
    my $results;

    if ($module_f eq "castep") {
        print $logFile "Using Castep Modules~\n";

        $results = Modules->CASTEP->Energy->Run($doc, Settings(
            SCFConvergence => 1e-005, 
            Quality => 'Coarse', 
            # PropertiesKPointQuality => 'Coarse',
        ));
        print $logFile "Castep finish!\n";

    } elsif ($module_f eq "dmol") {
        print $logFile "Using DMol Modules~\n";

        $results = Modules->DMol3->Energy->Run($doc, Settings(
            MaxMemory => 6144, 
            TheoryLevel => 'GGA', 
            NonLocalFunctional => 'PBE', 
            HybridFunctional => 'TPSSh', 
            Basis => 'DND', 
            BasisFile => '3.5', 
            OrbitalCutoffQuality => 'Fine', 
            CutoffType => 'Custom', 
            AtomCutoff => 7, 
            UseSmearing => 'Yes', 
            CalculateForces => 'Yes', 
        ));

        print $logFile "MMol finish!\n";

    }else {
        print $logFile "?what?,check you input!\n";
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

    # print $logFile "we get the energy:", $result_energy,"\n","and the forceList:\n";
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
        print $logFile join(" ", @array_f[$i .. $i + 2]), "\n" if $i + 2 < @array_f;
    }
}

