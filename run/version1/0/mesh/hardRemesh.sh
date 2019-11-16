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
#     Скрипт для генерации сетки заново c помощью утилиты snappyHexMesh
# 	  с копированием файлов геометрии
#
#------------------------------------------------------------------------------

# Удаление всех файлов созданных при предыдущем разбиении сетки
rm -r constant/extendedFeatureEdgeMesh
rm -r constant/polyMesh
rm -r constant/triSurface/*
rm -r ../geometry/*

# Копирование .stl файлов из папки 0/geometry
cp ../0/geometry/*.stl ../geometry/

# Регенерация сетки с нуля
sh firstMesh.sh

# ***************************************************************************** #