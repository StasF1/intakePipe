#!/bin/sh
#*---------------------------------*- sh -*----------------------------------*#
# =========                 |                                                 #
# \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox           #
#  \\    /   O peration     | Version:  5                                     #
#   \\  /    A nd           | Mail:     stas.stasheuski@gmail.com             #
#    \\/     M anipulation  |                                                 #
#*---------------------------------------------------------------------------*#

# Скрипт для запуска расчёта

# Копирование файлов сетки
cp -r ../mesh/constant/polyMesh constant
refineMesh -overwrite

# Запуск расчёта
simpleFoam | tee case.log
postProcess -func "patchAverage(p,name=inlet)" -latestTime | tee -a case.log
echo -ne '\007'
