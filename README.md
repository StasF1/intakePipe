# About intakePipe
The determine the characteristics of the intake ports of piston engines sometimes is tough thing to do. To ensure a high quality gas exchange and combustion, it requies a series of calculations for various valve lifts both to determine their flow characteristics and to evaluate the ability to generate a vortex in the cylinder during the intake period. So, it is necessary to change the solid-state model of the channel for each valve lift, adjust the grid generation parameters based on it, and carry out a CFD calculation. This makes the procedure for determining the characteristics of the intake channels is time consuming.

The purpose of this work was to create a method for determining the characteristics of the intake channels of piston engines using an open integrable platform OpenFOAM, which was used to solve the problems described above. Being a really handy tool, it allows automate the process of manually changing the solid model for each valve lift!

## Block diagramm of the algorythm
![blockDiagram](https://github.com/StasF1/intakePipe/wiki/src/images/blockDiagram.png)

# Requirements
1. **OpenFOAM v6** or higher 
2. **MATLAB**

# [Releases](https://github.com/StasF1/intakePipe/releases)
|Version|Description|Source code 📥|
|------:|:----------|:-------------|
[v0.1-beta](https://github.com/StasF1/intakePipe/tree/v0.1-beta)|Postproccessing using MATLAB and ParaView|[.tar.gz](https://github.com/StasF1/intakePipe/archive/v0.1-beta.tar.gz), [.zip](https://github.com/StasF1/intakePipe/archive/v1-beta.zip)|

# Usage
## CFD or OpenFOAM part
Directory *run/* has got three different versions of the geometry. In the *intakePipeDict* you can set some settings of the compilation (initial and finite strokes or calculation step). To start compilation of all three version run the script *AllVerRun* (which running the folowing scripts *verRun* in all *ver#/* folders). To start compilation in specified version folder run a *verRun* script in the *ver#/*. Every version folder (*ver#/*) has got a *0/* folder where you can set anything and the *geometry/*, where *.stl* files located.

The *verRun* script copies the *0/* directory, moves the valve to make the new stroke, generates the mesh and solves the case for that stroke with step. Every stroke will have its case folder *run/version#/<stroke>/* (where <stroke> is stroke in millimetres).

**Before running** the script open ParaView and load the state *case.pvsm* from *version#/0/* with ''`Load State...`''. Select *Swirl number* filter and change path to the *swirlNumberFilter.py* (the path **must** be **full**!), which is placed in *postProcessing/* directoty. Save *case.pvsm* replacing the original one with the ''`Save State...`''.

**⚠ In case if you need to recompilate smth**:

Because main script runs the others if you need to recompilate something you do not need to rerun the whole project. So, if you need to recompilate:
- all calculations for a certain stroke:
    ```bash
    shopt -s extglob
    rm -r !("0"|"geometry"|"verRun")
    0/./Allclean && 0/./scaleGeometry && ./verRun
    ```
- only a certain stroke:
    ```bash
    ./Allclean && ./scaleGeometry && ./setCurrentStroke && ./Allrun
    ```

## postProcessing
### MATLAB
The *solveVersion.sh* script makes *inletPatchPressures.dat* file  in *ver#/* directory with inlet patch pressures for every stroke.
In the directory *postProcessing/flowCoefficient/* run *Main.m* to calculate flow coeffiecient of intake pipe. It also considers three versions of minimal flow area (from I to III on the picture) or even if it is moves to the *d_2* diameter of the pipe.

![valveStep](https://github.com/StasF1/intakePipe/wiki/src/images/valveStep.png)

As a result we have got set of plots and one from them is a plot with flow coefficent for 3 versions of intake pipes:

![mu](https://github.com/StasF1/intakePipe/wiki/src/images/mu.png)

### ParaView
Every v*ersion#/<stroke>/* folder has got a *caseState.pvsm* file when you open it in the ParaView with ''`Load State...`'' it calculates swirl numbers in the cylinder automatically.

⚠ **In case if you need to make a simulation with another pipe geometry** - read [**Wiki**](https://github.com/StasF1/intakePipe/wiki/Home).

# Structure
```gitignore
intakePipe-v0.2
├── run
│   ├── ver1
│   │   ├── 0              # default case (valve is closed: stroke = 0 [mm])
│   │   └── geometry       # .stl files
│   ├── ver2
│   │   └── geometry
│   └── ver3
│       └── geometry
└── postProcessing
    ├── flowCoefficient    # MATLAB scripts to make plots
    └── swirlNumber        # ParaView filter & state
```
