# About intakePipe
The determine the characteristics of the intake ports of piston engines sometimes is tough thing to do. To ensure a high quality gas exchange and combustion, it requies a series of calculations for various valve lifts both to determine their flow characteristics and to evaluate the ability to generate a vortex in the cylinder during the intake period. So, it is necessary to change the solid-state model of the channel for each valve lift, adjust the grid generation parameters based on it, and carry out a CFD calculation. This makes the procedure for determining the characteristics of the intake channels is time consuming.

The purpose of this work was to create a method for determining the characteristics of the intake channels of piston engines using an open integrable platform OpenFOAM, which was used to solve the problems described above. Being a really handy tool, it allows automate the process of manually changing the solid model for each valve lift!

## Block diagramm of the algorythm
![blockDiagram](https://github.com/StasF1/intakePipe/wiki/images/blockDiagram.png)

# Requirements
1. **OpenFOAM v5** or higher 
2. **MATLAB**

# [Releases](https://github.com/StasF1/intakePipe/releases)
|Version|Description|Source code 📥|
|------:|:----------|:-------------|
[v2-beta](https://github.com/StasF1/intakePipe/tree/v2-beta)|Postproccessing using MATLAB and ParaView|[.tar.gz](https://github.com/StasF1/intakePipe/archive/v2-beta.tar.gz), [.zip](https://github.com/StasF1/intakePipe/archive/v2-beta.zip)|

# Usage
## CFD or OpenFOAM part
Directory `calculation/` has got three different versions of the geometry. In the *intakePipeDict.sh* you can set some settings of compilation (initial and finite strokes or calculation step). To start compilation of all three version run the script *Allrun.sh* (which running the script *solveVersion.sh* in all version#/ folders). To start compilation in specified version folder run a *solveVersion.sh* script in the `version#`. Every folder version has got a `0/` folder in which the normal OpenFOAM folders archived ( `case/` , `geometry/` , `mesh/` ) and the `STLs/` , where *.stl* files located.

The *solveVersion.sh* script copies the `0/` directory, moves the valve for the new stroke, generates the mesh and solves the case for that stroke with step. Every stroke will have its case folder `calculation/version#/<stroke>/`.

**Before running** the script open ParaView and load the state *caseState.pvsm* from `version#/0/case/` with ''`Load State...`''. Select *Swirl number* filter and change path to the *swirlNumberFilter.py* (the path **must** be **full**!), which is placed in `postProcess/` directoty. Save *caseState.pvsm* replacing the original one with the ''`Save State...`''.

**⚠ In case if you need to recompilate smth**:

Because main script runs the others if you need to recompilate something you do not need to rerun the whole project. So, if you need to recompilate:
- all calculations for the certain stroke – run a *solveCurrentStroke.sh* script in the `calculation/<stroke>/`
- only mesh for the certain stroke – run a *remesh.sh* or *hardRemesh.sh* script in the `calculation/<stroke>/mesh/` (_hardRemesh.sh_ deletes all mesh files and remakes them from `0/geometry`)
- only case for the certain stroke – run a *hardRerun.sh* script in the `calculation/<stroke>/case/`

## postProcessing
### MATLAB
The *solveVersion.sh* script makes *inletPatchPressures.txt* file  in `version#/` directory with inlet patch pressures for every stroke.
In the directory `postProcessing/flowCoefficient/` run *Main.m* to calculate flow coeffiecient of intake pipe. It also considers three versions of minimal flow area (from I to III on the picture) or even if it is moves to the *d_2* diameter of the pipe.

![valveStep](https://github.com/StasF1/intakePipe/wiki/images/valveStep.png)

As a result we have got set of plots and one from them is a plot with flow coefficent for 3 versions of intake pipes:

![mu](https://github.com/StasF1/intakePipe/wiki/images/mu.png)

### ParaView
Every `version#/#/case` folder has got a *caseState.pvsm* file when you open it in the ParaView with ''`Load State...`'' it calculates swirl numbers in the cylinder automatically.

⚠ **In case if you need to make a simulation with another pipe geometry** - read [**Wiki**](https://github.com/StasF1/intakePipe/wiki/Home).

# Structure
```gitignore
intakePipe-v0.1
├── calculation
│   ├── version1
│   │   ├── 0               # default case (valve is closed)
│   │   │   ├── case        # case files (results of CFD simulation)
│   │   │   ├── geometry    # scaled .stl files
│   │   │   └── mesh        # mesh files
│   │   └── STLs            # .stl files (don't scaled)
│   ├── version2
│   │   └── STLs
│   └── version3
│       └── STLs
└── postProcess
    └── flowCoefficient     # MATLAB scripts to make plots
```
