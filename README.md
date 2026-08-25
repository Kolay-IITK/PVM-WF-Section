# P-V-M-interaction-in-Wide-flange-steel-section

This repository contains the implementation of a two-dimensional fiber section for OpenSees that captures the interaction among axial force (P), shear (V), and bending moment (M) in I-shaped rolled and built-up doubly symmteric steel cross-sections.
The formulation is based on the fiber section approach proposed by Saritas and Filippou (2009) [1], together with the simplified shear strain distribution proposed by Ding et al. (2018) [2].

The key features of this implementation are as follows:
- Supports multiaxial fibers and is compatible with forceBeamColumn elements.  
- Implements a constant shear strain distribution in the web and web-flange junction and another constant shear strain in the flanges, which is a function of web shear strain, cross-sectional geometry, link length, and ultimate material strength.
- Allows different material properties for the web and flange fibers.
  
---
## Input Syntax
To define a wide-flange steel section with this proposed fiber section, use the following command:

section WFSection2d $secTag $matTagWeb $d $tw $bf $tf $nfw $nff -nd_shear $link_length $fu $matTagFlange

| Argument           | Type    | Description                                                                  |
| ------------------ | ------- | ---------------------------------------------------------------------------- |
| `$secTag`          | Integer | Unique section tag identifier                                                     |
| `$matTagWeb`          | Integer | Material tag  assigned to the web fibers                                                |
| `$d`               | Float   | Overall section depth                                             |
| `$tw`              | Float   | Web thickness                                                               |
| `$bf`              | Float   | Flange width                                                               |
| `$tf`              | Float   | Flange thickness                                                           |
| `$nfw`    | Integer | Number of fibers along the web depth                                      |
| `$nff` | Integer | Number of fibers in each flange region                                      |
| `$link_length` | Float   | Length of the link member |
| `$fu` | Float   | Ultimate strength of the steel material |
| `$matTagFlange` | Float   | Material tag assigned to fibers of the flange (Optional) |

## Note:

-  `$matTagFlange` is optional. If it is not specified, `$matTagWeb` is used for the entire cross-section; that is, the same material is assigned to both the web and flange fibers.
- `$nff` must be an even number to properly represent the assumed shear strain distribution in the flange regions. If an odd value is specified, $nff is automatically increased by one internally.

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


## Reference
[1] Afsin Saritas and Filip C. Filippou. Frame Element for Metallic Shear-Yielding Members under Cyclic Loading. Journal of Structural Engineering, 135(9):1115–1123, September 2009. ISSN 0733-9445, 1943-541X.  URL https://ascelibrary.org/doi/10.1061/%28ASCE%29ST.1943-541X.0000041.

[2] Ding, R., Nie, X. and Tao, M.-X. (2018), ‘Fiber beam–column element considering flange contribution for steel links under cyclic loads’, Journal of Structural Engineering 144(9), 04018131.

---
