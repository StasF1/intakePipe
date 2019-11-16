#!/bin/bash
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
#     solveVersion
#
# Description
#     Решение варианта проекта с увеличением хода клапана на шаг
#
#------------------------------------------------------------------------------

source ../intakePipeDict.sh

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

startVersionTime=`date +%s` # Включение секундомера для вывода времени расчёта

## Масштабирование файлов .stl
cd 0/geometry
printf 'Running surfaceTransformPoints (scaling .stl files) on %s\n' ${PWD}
sh scaleSTL.sh > scaleSTL.log
cd ../../

## Создание и решение подпроектов по шагу клапана
# Создание файла давлений на входном сечении по шагам клапана
printf '# Time       	average(p)\n' > inletPatchPressures.txt
stroke=$strokeStart
while [ $stroke -le $strokeEnd ]
do
	startStrokeTime=`date +%s` # Включение секундомера для вывода времени расчёта подпроекта
	strokeMetres=`echo "scale=3; $stroke*10^(-3)" | bc -l` # Сonverting stroke to metres
	
	# Создание папки подпроекта для шага клапана и изменение под него настроек
	mkdir $stroke
	cp -a 0/* $stroke
	cd $stroke/
	sed -i "s/strokeMetres/$strokeMetres/g" solveCurrentStroke.sh 
	
	sh solveCurrentStroke.sh # Генерация сетки и решение на ней
	
	# Запись в файл давления на входном сечении
	cd case/postProcessing/patchAverage\(p,name=inlet\)/0/
	tail -n1 surfaceFieldValue.dat >> ../../../../../inletPatchPressures.txt
	cd ../../../../../
	
	# Отображение времени расчёта подпроекта
	endStrokeTime=`date +%s`
	strokeTime=$((endStrokeTime-startStrokeTime))
	printf '   Stroke %s mm has being solved in %dh:%dm:%ds\n' $stroke\
		 $(($strokeTime/3600)) $(($strokeTime%3600/60)) $(($strokeTime%60))

	stroke=`echo "scale=1; $stroke + $strokeDelta" |bc` # Inreasing stroke by one step
done

# Отображение времени расчёта версии
endVersionTime=`date +%s`
versionTime=$((endVersionTime-startVersionTime))
printf '   All srokes have being solved in %dh:%dm:%ds\n'\
	 $(($versionTime/3600)) $(($versionTime%3600/60)) $(($versionTime%60))
echo -ne '\007' # звуковой сигнал

# ***************************************************************************** #










