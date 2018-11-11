#!/bin/bash
# Решение проекта с увеличением хода клапана на шаг

# ------------------------------------- Data ------------------------------------- #

# Задание хода клапана
strokeStart=4 # mm, первый ход клапана
strokeEnd=8 # mm, последний ход клапана
strokeDelta=1 # mm, шаг хода клапана (допустимы значения кратные одному милимметру)

# -------------------------------------------------------------------------------- #


# [[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[ Script ]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]] #

startProjectTime=`date +%s` # Включение секундомера для вывода времени расчёта

## Масштабирование файлов .stl
printf 'Scaling *.stl files...\n'
cd 0/geometry
sh scaleSTL.sh > scaleSTL.log 
printf '\nScaling *.stl files has being DONE.'
printf '\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n'
cd ../../

## Создание и решение подпроектов по шагу клапана
printf 'Solving cases by stokes:\n'

# Создание файла давлений на входном сечении по шагам клапана
printf '# Time       	average(p)\n' > inletPatchPressures.txt
stroke=$strokeStart
while [ $stroke -le $strokeEnd ]
do
	printf 'Solving stroke = %s mm:\n' $stroke
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
	
	# Сохранение времени расчёта подпроекта в project.log
	printf '\nStroke %s mm has being SOLVED in ' $stroke
	endStrokeTime=`date +%s`
	solveStrokeTime=$((endStrokeTime-startStrokeTime))
	printf '%dh:%dm:%ds\n\n'\
		 $(($solveStrokeTime/3600)) $(($solveStrokeTime%3600/60)) $(($solveStrokeTime%60))

	stroke=`echo "scale=1; $stroke + $strokeDelta" |bc` # Inreasing stroke by one step
done
printf '\nThe project has being SOLVED.'
printf '\n~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n'

# Отображение времени расчёта проекта
endProjectTime=`date +%s`
solveProjectTime=$((endProjectTime-startProjectTime))
printf '#######################\n'
printf 'Solve time: %dh:%dm:%ds\n'\
	 $(($solveProjectTime/3600)) $(($solveProjectTime%3600/60)) $(($solveProjectTime%60))
echo -ne '\007' # звуковой сигнал










