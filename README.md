# intakePipe
Calculates flow coefficient for intake pipe. Also can compare different forms of intake pipes by it.

# Compilation
## CFD or OpenFOAM part
Directory `CFDOpenFOAM/` has got three different versions of geometry. To start complilation in any version run a solveProject.sh script (in the script you can change initial and finite strokes).\
Every folder version has got a `0/` folder in which the normal OpenFOAM folders archived ( `case/` , `geometry/` , `mesh/` ). In the `0/geometry/` .stl files located. Script copies the `0/` directory, moves the valve for the new stroke, generates the mesh and solves the case for that stroke with 1 mm step. Every stroke will have its case folder `CFDOpenFOAM/<stroke>/`.

#### If you need to recompilate:
- whole stroke – run a solveCurrentStroke.sh script in the `CFDOpenFOAM/<stroke>/`
- only mesh – run a remesh.sh or hardRemesh.sh script in the `CFDOpenFOAM/<stroke>/mesh/`
- only case – run a hardRerun.sh script in the `CFDOpenFOAM/<stroke>/mesh/`

hardRemesh.sh deletes all files of mesh and remakes them from `0/geometry`

## post processing or MATLAB part
The solveProject.sh script stroke makes inletPatchPressures.txt file with inlet patch pressures for every stoke.
In the directory `/`

### Block diagramm of the algorythm
![alt text](https://github.com/StasF1/READMEPictures/blob/master/intakePipe/blockDiagram.png)
