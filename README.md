# P-V-M-interaction-in-Wide-flange-steel-section

This repository contains the implementation of a 2-D fiber section in OpenSees to capture the interaction between **axial force (P)**, **shear (V)**, and **bending moment (M)** in wide-flange steel sections. It is based on the theoretical model proposed by **Saritas and Filippou (2009)**[1].

Unlike the existing OpenSees wide-flange section integration command, which assumes a **constant shear strain distribution** with a shear correction factor, this new implementation introduces a **parabolic shear strain distribution** across the web depth, providing improved accuracy for shear-flexure interaction. 
In this implementation:

---
## Key Features
- Supports **multiaxial fibers** and is compatible with `forceBeamColumn` elements.  
- Implements a **parabolic shear strain distribution** across the web and a consistent shear strain assumption in the flanges.   
---
## Usage
To define a wide-flange steel section, use the following command:

section WFSection2d $secTag $matTag $d $tw $bf $tf $nfw $nff -nd_shear $alpha

| Argument           | Type    | Description                                                                  |
| ------------------ | ------- | ---------------------------------------------------------------------------- |
| `$secTag`          | Integer | Section tag identifier                                                     |
| `$matTag`          | Integer | Material tag for fibers                                                    |
| `$d`               | Float   | Section depth (overall height)                                              |
| `$tw`              | Float   | Web thickness                                                               |
| `$bf`              | Float   | Flange width                                                               |
| `$tf`              | Float   | Flange thickness                                                           |
| `$nfw`    | Integer | Number of fibers across the web depth                                      |
| `$nff` | Integer | Number of fibers in each flange region                                      |
| `$alpha` | Float   | Non-dimensional shear parameter:<br> $\displaystyle \alpha = \frac{2 t_f b_f}{(d - 2 t_f) t_w}$ |

## Example usage
```tcl
#Section dimensions
set d   0.86
set tw  0.028
set bf  0.45
set tf  0.045

#Compute non-dimensional shear parameter
set alpha [expr 2.0*$tf*$bf/(($d-2.0*$tf)*$tw)]

#Define section
section WFSection2d $secTag $matTag $d $tw $bf $tf $nfw $nff -nd_shear $alpha
```

##  Note

-`-nd_shear` flag activates the parabolic shear strain distribution.  

## 📖 Reference
[1] Afsin Saritas and Filip C. Filippou. Frame Element for Metallic Shear-Yielding Members under Cyclic Loading. Journal of Structural Engineering, 135(9):1115–1123, September 2009. ISSN 0733-9445, 1943-541X.  URL https://ascelibrary.org/doi/10.1061/%28ASCE%29ST.1943-541X.0000041.

---
