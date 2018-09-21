#!/bin/sh
#*---------------------------------*- sh -*----------------------------------*#
# =========                 |                                                 #
# \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox           #
#  \\    /   O peration     | Version:  5                                     #
#   \\  /    A nd           | Mail:     stas.stasheuski@gmail.com             #
#    \\/     M anipulation  |                                                 #
#*---------------------------------------------------------------------------*# 

# Скрипт для генерации сетки

# Смещение клапана на его ход
cd ../geometry
export FILE="valve.stl"
surfaceTransformPoints -translate '(0 0 strokeToReplace)' $FILE $FILE # z = stroke_ToReplace

# Генерация сетки
cd ../mesh/
cp ../geometry/*.stl constant/triSurface
surfaceFeatureExtract
blockMesh
snappyHexMesh -overwrite
echo -ne '\007' # paraview mesh.foam &
