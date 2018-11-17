The determine the characteristics of the intake ports of piston engines sometimes is tough thing to do. To ensure a high quality gas exchange and combustion, it requies a series of calculations for various valve lifts both to determine their flow characteristics and to evaluate the ability to generate a vortex in the cylinder during the intake period. So, it is necessary to change the solid-state model of the channel for each valve lift, adjust the grid generation parameters based on it, and carry out a CFD calculation. This makes the procedure for determining the characteristics of the intake channels is time consuming.
The purpose of this work was to create a method for determining the characteristics of the intake channels of piston engines using an open integrable platform OpenFOAM, which was used to solve the problems described above. Being a really handy tool, it allows automate the process of manually changing the solid model for each valve lift!

# Block diagramm of the algorythm

![alt text](https://github.com/StasF1/READMEPictures/blob/master/intakePipe/blockDiagram.png)

# CFD or OpenFOAM part

Directory `calculation/` has got three different versions of the geometry. To start compilation in any version run a *solveProject.sh* script (in the script you can change initial and finite strokes). Every folder version has got a `0/` folder in which the normal OpenFOAM folders archived ( `case/` , `geometry/` , `mesh/` ) and the `STLs/` , where *.stl* files located. 

The script *solveProject.sh* copies the `0/` directory, moves the valve for the new stroke, generates the mesh and solves the case for that stroke with 1 mm step. Every stroke will have its case folder `CFDOpenFOAM/<stroke>/`.

**Before run** the script open ParaView and load the state *caseState.pvsm* from `version#/0/case/` with ''`Load State...`''. Select *Swirl number* filter and change path to the *swirlNumberFilter.py* (the path **must** be **full**!), which is placed in `postProcess/` directoty. Save *caseState.pvsm* replacing the original one with the ''`Save State...`''.

#### In case if you need to recompilate smth:

Because main script runs the others if you need to recompilate something you do not need to rerun the whole project. So, if you need to recompilate:
- all calculations for the certain stroke – run a *solveCurrentStroke.sh* script in the `calculation/<stroke>/`
- only mesh for the certain stroke – run a *remesh.sh* or *hardRemesh.sh* script in the `calculation/<stroke>/mesh/` (_hardRemesh.sh_ deletes all mesh files and remakes them from `0/geometry`)
- only case for the certain stroke – run a *hardRerun.sh* script in the `calculation/<stroke>/case/`

# postProcessing

## MATLAB

The *solveProject.sh* script makes *inletPatchPressures.txt* file  in `version#/` directory with inlet patch pressures for every stoke.
In the directory `postProcessing/flowCoefficient/` run *Main.m* to calculate flow coeffiecient of intake pipe. It also considers three versions of minimal flow area (from I to III on the picture) or even if it is moves to the *d_2* diameter of the pipe.
![alt text](https://github.com/StasF1/READMEPictures/blob/master/intakePipe/threeCones.png)

In result we have got set of plots and one from them is a plot with flow coefficent for 3 versions of intake pipes:
![alt text](https://github.com/StasF1/READMEPictures/blob/master/intakePipe/mu.png)

## Paraview

Every `version#/#/case` folder has got a *caseState.pvsm* file when you open it in the ParaView with ''`Load State...`'' it calculates swirl numbers in the cylinder automatically.

# Compilation another pipe geometry

## CFD or OpenFOAM part

1. **Geometry files:**

    1. To recompilate any other pipe geometry make new folder (by copying existing `version#/`) to directory `calculation/`. 
    2. In the `STLs` put geometry files of the new pipe, which it **must** be splitted for four parts: *inlet.stl*, *outlet.stl*, *valve.stl*, *walls.stl*.
    3. Valve **must** be closed! Script moves it later automaticaly.

2. **Mesh:**
    In `<yourVersion>/0/mesh/system/` for new dimensions of the pipe change:

    1. Parameters of the _blockMeshDict_ .
    2. Parameters of the _snappyHexMeshDict_:
     - *line 63*: set `radius` for the radius of the valve
     - *line 105*: in `features` change refinement level nearby walls
     - _line 139_: in `refinementSurfaces` change refinement levels
     - _line 202_: set `locationInMesh` anywhere **inside** pipe geometry
     - _line 252_: in `addLayersControls` change refinement parameters

3. **Boundary condtions:**
    In `<yourVersion>/0/case/0/` for new dimensions of the pipe change boundary conditions in files: *p*, *U*, *epsilon*, *k*

4. **Set number of strokes:**

    In `<yourVersion>/` **open** script  *solveProject.sh* and set:

    - `strokeStart` - stroke of initial calculation (**only int type!**)
    - `strokeEnd` - stroke of finite calculation (**only int type!**)
    - `strokeDelta` - pitch for strokes (**only int type!**)

# postProcessing

## MATLAB

- In _flowCoefDict.m_ change values for your calculation
- If it is only one version of the pipe comment two others in _Main.py_
- run _Main.py_ script

## Paraview

- Change data in *swirlNumberFilter.py*

- Every `version#/#/case` folder has got a *caseState.pvsm* file when you open it in the ParaView with "`Load State...`" it calculates swirl numbers in the cylinder automatically. But a swirl numbers plot of one version of geometry you have to make manually. **_¯\\(ツ)/¯_**