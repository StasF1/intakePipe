#!/bin/sh
#*---------------------------------*- sh -*----------------------------------*#
# =========                 |                                                 #
# \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox           #
#  \\    /   O peration     | Version:  5                                     #
#   \\  /    A nd           | Mail:     stas.stasheuski@gmail.com             #
#    \\/     M anipulation  |                                                 #
#*---------------------------------------------------------------------------*#

# Скрипт для генерации сетки заново с копированием файлов геометрии

# Удаление всех файлов созданных при предыдущем разбиении сетки
rm -r constant/extendedFeatureEdgeMesh
rm -r constant/polyMesh
rm -r constant/triSurface/*
rm -r ../geometry/*

# Копирование .stl файлов из папки 0/geometry
cd ..geometry/
cp ../0/geometry/*.stl .

# Регенерация сетки с нуля
cd -
sh firstMesh.sh |& tee meshReport.txt
