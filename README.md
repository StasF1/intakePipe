# intakePipe
Calculates flow coefficient for intake pipe. Also can compare different forms of intake pipes by it.

# Description
## CFD or OpenFOAM part
Directory `CFDOpenFOAM/` has got three different versions of geometry. To start complilation in any version run a solveProject.sh script (in the script you can change initial and finite strokes).\
Every folder version has got a `0/` folder in which the normal OpenFOAM folders archived ( `case/` , `geometry/` , `mesh/` ). In the `0/geometry/` .stl files located. Script copies the `0/` directory, moves the valve for the new stroke, generates the mesh and solves the case for that stroke with 1 mm step. Every stroke will have its case folder `CFDOpenFOAM/<stroke>/`.

## postProcessing or MATLAB part
The solveProject.sh script stroke makes inletPatchPressures.txt file with inlet patch pressures for every stoke.
In the directory `postProcessing` run Main.m to calculate flow coeffiecient of intake pipe. It also considers three versions of minimal flow area (from I to III) or even if it is in the pipe (d_2).
![alt text](https://github.com/StasF1/READMEPictures/blob/master/intakePipe/threeCones.png)

In result we have got set of plots and one from them is a plot with flow coefficent for 3 versions of intake pipes:
![alt text](https://github.com/StasF1/READMEPictures/blob/master/intakePipe/mu.png)

### Block diagramm of the algorythm: [TRANSLATION IN PROGRESS]
![alt text](https://github.com/StasF1/READMEPictures/blob/master/intakePipe/blockDiagram.png)

# Compilation another pipe geometry

[IN PROGRESS]

#### In case if you need to recompilate smth:
- for whole stroke – run a solveCurrentStroke.sh script in the `CFDOpenFOAM/<stroke>/`
- for only mesh – run a remesh.sh or hardRemesh.sh script in the `CFDOpenFOAM/<stroke>/mesh/`
- for only case – run a hardRerun.sh script in the `CFDOpenFOAM/<stroke>/mesh/`

hardRemesh.sh deletes all files of mesh and remakes them from `0/geometry`
