#!/bin/sh
#*---------------------------------*- sh -*----------------------------------*#
# =========                 |                                                 #
# \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox           #
#  \\    /   O peration     | Version:  5                                     #
#   \\  /    A nd           | Mail:     stas.stasheuski@gmail.com             #
#    \\/     M anipulation  |                                                 #
#*---------------------------------------------------------------------------*# 

# Скрипт для регенерации сетки

# Перезапись .stl файлов в /mesh/constant/triSurface/
cd ../mesh/
rm -r constant/extendedFeatureEdgeMesh
rm -r constant/triSurface/*
cp ../geometry/*.stl constant/triSurface
surfaceFeatureExtract

# Регенерация сетки
rm -r constant/polyMesh
blockMesh
snappyHexMesh -overwrite
echo -ne '\007' # paraview foam.foam &