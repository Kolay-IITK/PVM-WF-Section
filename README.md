# P–V–M Interaction in Wide-Flange Steel Sections

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

```tcl
# Command format
section WFSection2d $secTag $matTag $d $tw $bf $tf $nfw $nff -nd_shear $alpha

| Argument           | Type    | Description                                                                  |
| ------------------ | ------- | ---------------------------------------------------------------------------- |
| `$secTag`          | Integer | Section tag identifier.                                                      |
| `$matTag`          | Integer | Material tag for fibers.                                                     |
| `$d`               | Float   | Section depth (overall height).                                              |
| `$tw`              | Float   | Web thickness.                                                               |
| `$bf`              | Float   | Flange width.                                                                |
| `$tf`              | Float   | Flange thickness.                                                            |
| `$numFibersWeb`    | Integer | Number of fibers across the web depth.                                       |
| `$numFibersFlange` | Integer | Number of fibers in each flange region.                                      |
| `-nd_shear $alpha` | Float   | Non-dimensional shear parameter:<br> `α = 2 * tf * bf / ((d - 2 * tf) * tw)` |








