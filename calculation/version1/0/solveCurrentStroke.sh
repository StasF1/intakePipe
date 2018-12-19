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
#     intakePipeDict
#
# Description
#     Регенерирует сетку при новом ходе клапана и находит решение
#
#------------------------------------------------------------------------------

# Задание хода клапана
stroke=-0strokeMetres

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

# Изменение хода клапана
cd mesh/
sed -i "s/strokeToReplace/$stroke/g" firstMesh.sh

# Изменение размера цилиндра для измельчения сетки под ход клапана в
# словаре snappyHexMeshDict
cd system/
sed -i "s/strokeToReplace/$stroke/g" snappyHexMeshDict
# sed "s/strokeToReplace/$stroke/g" snappyHexMeshDictToRepl > snappyHexMeshDict

# Генерация сетки
printf '  Meshing...'
cd ../
sh firstMesh.sh > mesh.log
checkMesh >> mesh.log

# Запуск расчёта
printf '\n  Solving the case...'
cd ../case/
sh firstRun.sh > case.log

# ***************************************************************************** #
