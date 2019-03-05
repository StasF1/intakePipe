#!/bin/sh
#-----------------------------------------------------------------------------#
# =========                 |
# \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox
#  \\    /   O peration     | Website:  https://github.com/StasF1/intakePipe
#   \\  /    A nd           | Version:  6
#    \\/     M anipulation  |
#------------------------------------------------------------------------------
# License
#     This program is free software: you can redistribute it and/or modify it
#     under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
#
#     This program is distributed in the hope that it will be useful, but
#     WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
#     or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
#     for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with OpenFOAM.  If not, see <http://www.gnu.org/licenses/>.
#
# Script
#     solveProject
#
# Description
#     Скрипт для генерации сетки c помощью утилиты snappyHexMesh
#
#------------------------------------------------------------------------------

# Смещение клапана на его ход
cd ../geometry
export FILE="valve.stl"
surfaceTransformPoints -translate '(0 0 strokeToReplace)' $FILE $FILE # z = stroke_ToReplace

# Генерация сетки
cd ../mesh/
cp ../geometry/*.stl constant/triSurface
surfaceFeatureExtract | tee mesh.log
blockMesh | tee -a mesh.log
snappyHexMesh -overwrite | tee -a mesh.log
echo '\007' # paraview mesh.foam &

# ***************************************************************************** #
