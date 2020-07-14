# About intakePipe
The determine the characteristics of the intake ports of piston engines
sometimes is tough thing to do. To ensure a high quality gas exchange and
combustion, it requies a series of calculations for various valve lifts both
to determine their flow characteristics and to evaluate the ability to generate
a vortex in the cylinder during the intake period. So, it is necessary to
change the solid-state model of the channel for each valve lift, adjust the
grid generation parameters based on it, and carry out a CFD calculation. This
makes the procedure for determining the characteristics of the intake channels
is time consuming.

The purpose of this work was to create a method for determining the
characteristics of the intake channels of piston engines using an open
integrable platform OpenFOAM, which was used to solve the problems described
above. Being a really handy tool, it allows automate the process of manually
changing the solid model for each valve lift!

## Block diagramm of the algorythm
![blockDiagram](https://github.com/StasF1/intakePipe/wiki/src/images/blockDiagram-0.2.png)

# Requirements
1. **OpenFOAM** - tested using **v6** and **v7**
1. **Python3** with **NumPy** & **Matplotlib** libraries - tested using Python
    *v3.7.4* with NumPy *v1.8.0rc1* & Matplotlib *v1.3.1*


# Usage
## Run
Directory *run/* has got three different versions of the geometry. In the
*strokeDict* you can set some settings of the compilation (initial and finite
strokes or calculation step). To start compilation of all three version run the
script *makeDesigns* (which running the folowing script *makeStrokes* in all
*design#/* folders). To start compilation in specified version folder run a
*makeStrokes* script in the *design#/*. Every version folder (*design#/*) has
got a *stroke_0mm/* folder where you can set anything and the *geometry/*,
where *.stl* files located.

The *makeStrokes* script copies the *stroke_0mm/* directory, moves the valve to
make the new stroke, generates the mesh and solves the case for that stroke with
step. Every stroke will have its case folder *run/design#/stroke_<stroke>mm/*
(where <stroke> is stroke in millimetres).

**Before running** the script open ParaView and load the state *case.pvsm* from
*design#/stroke_0mm/* with ''`Load State...`''. Select *Swirl number* filter
and change path to the *swirlNumberFilter.py* (the path **must** be **full**!),
which is placed in *postProcessing/* directoty. Save *case.pvsm* replacing the
original one with the ''`Save State...`''.

**⚠ In case if you need to recompilate smth**:

Because main script runs the others if you need to recompilate something you do
not need to rerun the whole project. So, if you need to recompilate:
- all calculations for a certain stroke:
    ```bash
    shopt -s extglob
    rm -r !("stroke_0mm"|"geometry"|"makeStrokes")
    stroke_0mm/./Allclean && ./makeStrokes && foamRunTutorials -skipFirst
    ```
- only a certain stroke:
    ```bash
    ./Allclean && ./Allrun
    ```

## Post-process
### Python 3
OpenFOAM post-processing functions create _postProcessing/_ folder with data
files. To initiate calculation flow coeffiecients of intake pipes using .dat
files run *postProcessing.py* python script (in the directory
*postProcessing/flowCoefficient/*). It also considers three versions of minimal
flow area (from I to III on the picture or when it moved to the *d_2* diameter).

![valveStep](https://github.com/StasF1/intakePipe/wiki/src/images/valveStep.png)

As a result we have got set of plots and one from them is a plot with flow
coefficent for 3 versions of intake pipes:

![mu](https://github.com/StasF1/intakePipe/wiki/src/images/mu.png)

### ParaView
_postProcessing/swirlNumber_ folder has got a *swirlNumber.pvsm* ParaView state
file when you open it in the ParaView using ''`Load State...`'' it will
calculate swirl numbers in the cylinder automatically.

---
⚠ **In case if you need to make a simulation with another pipe geometry** -
read [**Wiki**](https://github.com/StasF1/intakePipe/wiki/Home).


# Structure
```gitignore
intakePipe-0.3
├── run
│   ├── design0
│   │   ├── stroke_2mm     # default case
│   │   └── geometry       # .stl files
│   ├── design1
│   │   └── geometry
│   └── design2
│       └── geometry
└── postProcessing
    ├── flowCoefficient    # Python3 script to make flow coeffiecient plot
    └── swirlNumber        # ParaView filter & state file
```