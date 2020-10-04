# About intakePipe
The determine the characteristics of the intake ports of piston engines
sometimes is tough thing to do.
To ensure a high quality gas exchange and combustion, it requies a series of
calculations for various valve lifts both to determine their flow
characteristics and to evaluate the ability to generate a vortex in the
cylinder during the intake period. So, it is necessary to change the
solid-state model of the channel for each valve lift, adjust the grid
generation parameters based on it, and carry out a CFD calculation.
This makes the procedure for determining the characteristics of the intake
channels is time consuming.

The purpose of this template is to create a method for determining the
characteristics of the intake channels of piston engines using an open
integrable platform OpenFOAM, which was used to solve the problems described
above.
Being a handy tool, it allows automate the process of manually changing
the solid model for each valve lift!

<!-- ## Block diagramm of the algorythm
![blockDiagram](https://github.com/StasF1/intakePipe/wiki/src/images/blockDiagram-0.2.png) -->


# Requirements
1. **OpenFOAM** - tested using **v6**, **v7** and **v8**
1. **Python3** with [NumPy](https://numpy.org/) and
    [Matplotlib](https://matplotlib.org/) libraries (- )tested using Python
    *v3.8.2* with NumPy *v1.18.3* & Matplotlib *v3.2.1*)


# Usage
## Pre-Process
- Prepare a pipe geometry and save it as *inlet.stl*, *outlet.stl*,
*valve.stl*, *walls.stl* at *projectTemplate/design0/geometry/*.
- Edit OpenFOAM case settings at *projectTemplate/design0/geometry/stroke_2mm/*
    if required.

## Run
Directory *projectTemplate/* has got three different versions of the geometry.
In the *projectDict* you can set some settings of the run (initial, finite
valve strokes and stroke step).
The *makeStrokes* script clones the parent *stroke_2mm/* OpenFOAM case.
Every stroke will have its own case *projectTemplate/design<i>/stroke_<h>mm/*
(where <h> is valve stroke in millimetres).

- To calculate all three design versions: run a *makeDesigns* script (which
    runs the folowing *makeStrokes* script in all *design<i>/* folders) and
    then run the `foamRunTutorials` command.
- To calculate specified design only: run a *makeStrokes* script in the
    *design<i>/* and then run the `foamRunTutorials` command.
    Every design folder must have a *stroke_2mm/* parent OpenFOAM case and a
    *geometry/* folder (with *.stl* files - ).

**⚠ In case if you need to recompilate smth**:

Because main script runs the others if you need to recompilate something you do
not need to rerun the whole project. So, if you need to recompilate:
- all calculations for a certain stroke:
    ```bash
    shopt -s extglob
    rm -r !("stroke_2mm"|"geometry"|"makeStrokes")
    stroke_2mm/./Allclean && ./makeStrokes && foamRunTutorials -skipFirst
    ```
- only a certain stroke:
    ```bash
    ./Allclean && ./Allrun
    ```

## Post-process
### Jupyter Notebook
OpenFOAM post-processing functions create a _postProcessing/_ folder with data
files.
To initiate calculation intake pipes discharge coefficient using .dat files run
*dischargeCoefficient.py* run postProcess.ipynb notebook 
It considers three versions of minimal flow area (from I to III on the
picture or when it moved to the *d_2* diameter).
![valveStep](https://github.com/StasF1/intakePipe/wiki/src/images/valveStep.png)

As a result, there is a swirl numbers graph and a graph with discharge
coefficient plots for three design versions of an intake pipe:
![mu](https://github.com/StasF1/intakePipe/wiki/src/images/mu.png)

---
⚠ **In case if you need to make a simulation with another pipe geometry** -
read [**Wiki**](https://github.com/StasF1/intakePipe/wiki/Home).


# Structure
```gitignore
intakePipe-0.4
└── projectTemplate     # project folder
    ├── design0
    │   ├── stroke_2mm  # default/parent case w/ settings
    │   └── geometry    # .stl files
    ├── design1
    │   └── geometry
    ├── design2
    │   └── geometry
    └── postProcessing  # python3 post-processing scripts
        ├── dischargeCoefficient
        └── swirlNo     # python ParaView filter & state file
```