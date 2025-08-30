# P-V-M-interaction-in-steel Wide-flange-sections


set alpha [expr 2.0*$tf*$bf/(($d-2.0*$tf)*$tw)]
section WSection2d $secTag $matTag $d $tw $bf $tf 10 5 -nd_shear $alpha
