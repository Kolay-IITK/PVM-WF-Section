# ==============================================================================
# OpenSees TCL: Fiber Section for I-section to capture PVM interaction with GenPlasticity material
# Structural Model: EBF Shear Link under Cyclic Loading
# Units: kN, mm
# ==============================================================================

wipe; # Clear OpenSees model

# ------------------------------------------------------------------------------
# 1. Model & Node Definition
# ------------------------------------------------------------------------------
model basic -ndm 2 -ndf 3

set L 711.2; # Member length (mm)

# Nodes: node Tag X Y
node 1   0.0  0.0
node 2    $L  0.0

# Boundary Conditions: fix nodeTag UX UY RZ
fix 1 1 1 1  ; # Fully fixed base
fix 2 1 0 1  ; # Guided boundary: free along UY (DOF 2)

# ------------------------------------------------------------------------------
# 2. Material Definitions (Generalized Plasticity)
# ------------------------------------------------------------------------------
set nu 0.3

# --- Web Material Parameters ---
set matTagweb 1
set Eweb 131.492
set sigweb1 0.154
set Hisoweb 0.0217
set Hkinweb 0.4863
set Parameter_phi_web 0.1311
set Parameter_delta_web 15.9556
set sigweb2 0.069
set Parameter_phi_2_web 0.3232
set Parameter_delta_2_web 14.4847

nDMaterial GenPlasticity $matTagweb $Eweb $nu $sigweb1 $Hisoweb $Hkinweb \
                         $Parameter_delta_web $Parameter_phi_web \
                         $sigweb2 $Parameter_delta_2_web $Parameter_phi_2_web 

# ------------------------------------------------------------------------------
# 3. Section & Geometric Transformation Setup
# ------------------------------------------------------------------------------
set secTag 1
set d  454.15  ; # Total depth (mm)
set bf 152.00  ; # Flange width (mm)
set tf  13.23  ; # Flange thickness (mm)
set tw   7.98  ; # Web thickness (mm)

# Section definition (WFSection2d)
section WFSection2d $secTag $matTagweb $d $tw $bf $tf 10 5 -nd_shear $L 403.34 $matTagweb

# Geometric Transformation
set LTrans 1
geomTransf Linear $LTrans

# ------------------------------------------------------------------------------
# 4. Element Definition
# ------------------------------------------------------------------------------
set Np 6 ; # Number of Gauss-Lobatto integration points
element forceBeamColumn 1 1 2 $Np $secTag $LTrans -integration Lobatto

# ------------------------------------------------------------------------------
# 5. Recorders
# ------------------------------------------------------------------------------
recorder Node -file nodes_PVM.txt -node 2 -dof 1 2 3 disp
recorder Element -file Elm1F_PVM.txt -ele 1 force

# ------------------------------------------------------------------------------
# 6. Load Pattern & Analysis Setup
# ------------------------------------------------------------------------------
pattern Plain 2 Linear {
    load 2 0.0 1.0 0.0 ; # Apply unit transverse load at Node 2 (UY)
}

system SparseGeneral -piv
constraints Transformation
test NormDispIncr 1.0e-6 1000
algorithm Newton -initial
numberer RCM
analysis Static

# ------------------------------------------------------------------------------
# 7. Loading Protocol Execution (Same-Directory disp_history.dat)
# ------------------------------------------------------------------------------
set scriptDir [file dirname [file normalize [info script]]]
set datFile   [file join $scriptDir "disp_history.dat"]

if {![file exists $datFile]} {
    error "ERROR: Required displacement history file '$datFile' not found in current directory."
}

set fp [open $datFile r]
set currentDisp 0.0
set nodeTag 2
set dofTag 2

while {[gets $fp targetDisp] >= 0} {
    set targetDisp [string trim $targetDisp]
    if {$targetDisp ne ""} {
        set dU [expr {$targetDisp - $currentDisp}]
        if {abs($dU) > 1.0e-12} {
            integrator DisplacementControl $nodeTag $dofTag $dU
            set ok [analyze 1]
            if {$ok != 0} {
                puts "WARNING: Convergence failed at target displacement: $targetDisp mm"
                break
            }
            set currentDisp $targetDisp
        }
    }
}
close $fp

puts "Finished TCL Analysis Successfully."