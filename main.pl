#!/usr/bin/perl
use Data::Dumper;

sub non_linear {
    @arr = (); 
    @x= @_[0];
    $d = $_[1]; 

    if($d eq 'True'){
        for ($i=0; $i < 3; $i++) {
            for ($j=0; $j < 3; $j++) {
                $f = $x[0][$i][$j];
                $f_val = $f*(1-$f);
                $arr[$i][$j] = $f_val;
            }
        }
    }else{
        for ($i=0; $i < 3; $i++) {
            for ($j=0; $j < 3; $j++) {
                $f = $x[0][$i][$j];
                $f = $f * -1; 
                $e = 2.718281**$f;
                $f_val = 1/(1+$e);
                $arr[$i][$j] = $f_val;
            }
        }
    }
    # print "Output Arr: \n"; 
    # print Dumper (\@arr);
    return @arr; 
}

sub dotprod {
    @vec_a= @_[0];
    @vec_b= @_[1];
    
    @sum = ();

    for ($i=0; $i < 3; $i++) {
        for ($j=0; $j < 3; $j++) {
            $sum[$i][$j] = $vec_a[0][$i][0] * $vec_b[0][0][$j] + $vec_a[0][$i][1]*$vec_b[0][1][$j] + $vec_a[0][$i][2]*$vec_b[0][2][$j];
        }
    }
    return @sum;
}

sub set_array {
    @arr = (); 
    $x= $_[0];
    $y= $_[1];
    for ($i=0; $i < $x; $i++) {
        for ($j=0; $j < $y; $j++) {
            $arr[$i][$j] =  rand();
        }
    }
    return @arr; 
}

@X = ([0,0,1],
      [0,1,1],
      [1,0,1],
      [1,1,1]);

@y = ([0],
	  [1],
	  [1],
	  [0]);

@syn0 = set_array(3,3);

@syn1 = set_array(3,3);

for ($k=0; $k < 500; $k++) {

    @l0 = @X;
    @l1 = ();
    @l1_error = ();
    @l1_delta = ();
    @l2 = ();
    @l2_error = ();
    @l2_delta = ();

    # Feed Forward layer 2
    @l1 = dotprod(\@l0,\@syn0);
    @l1 = non_linear(\@l1,'False');


    # Feed Forward layer 3
    @l1 = dotprod(\@l1,\@syn1);
    @l2 = non_linear(\@l1,'False');

    # Calculate target miss 
    for ($i = 0; $i<3; ++$i) {
        for ($j=0; $j < 3; $j++) {
            $l2_error[$i][$j] = $Y[$i][0] - $l2[$i][$j];
        }
    }

    # print "L2 Error: \n"; 
    #print Dumper (\@l2_error);

    # Set target direction
    @set_delta = non_linear(@l2,'True');

    for ($i = 0; $i<3; ++$i) {
        for ($j=0; $j < 3; $j++) {
            $l2_delta[$i][$j] = $l2_error[$i][$j] * $set_delta[$i][$j] ;
        }
    }
    # print "Syn L1 Delta: \n"; 
    # print Dumper (\@l2_delta);

    # Determine target direction?
    @l1_error = dotprod(\@l2_delta,\@syn1);

    @set_delta = non_linear(@l1,'True');
    for ($i = 0; $i<3; ++$i) {
        for ($j=0; $j < 3; $j++) {
            $l1_delta[$i][$j] = $l1_error[$i][$j] * $set_delta[$i][$j] ;
        }
    }
    
    # print "Syn L1 Delta: \n"; 
    # print Dumper (\@l1_delta);

    @l1_syn1 = dotprod(\@l1,\@l2_delta);
    for ($i = 0; $i<3; ++$i) {
        for ($j=0; $j < 3; $j++) {
            $syn1[$i][$j] = $syn1[$i][$j] + $l1_syn1[$i][$j];
        }
    }

    @l0_syn0 = dotprod(\@l0,\@l1_delta);
    for ($i = 0; $i<3; ++$i) {
        for ($j=0; $j < 3; $j++) {
            $syn0[$i][$j] = $syn0[$i][$j] + $l0_syn0[$i][$j];
        }
    }
    
}

print "Output L1: \n"; 

print Dumper (\@l1);

