#!/bin/bash
# Решение проекта с увеличением хода клапана на шаг

# -------------------------------------------------- Data -------------------------------------------------- #

# Для запуска и записи ПОЛНОГО отчёта в терминале ввести: bash solveProject.sh | tee fullReport.txt && exit
# По окончании решения терминал зaкроется автоматически!

# Задание хода клапана
strokeStart=2 # mm, первый ход клапана
strokeEnd=14 # mm, последний ход клапана
strokeDelta=1 # mm, шаг хода клапана (допустимы значения кратные одному милимметру)

# Указание пути к файлам .stl для их копирования
cp -r /media/psf/HDD/Diploma/Drawings/intakePipe/version2/stl/*.stl 0/geometry

# ---------------------------------------------------------------------------------------------------------- #



# [[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[ Script ]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]] #

startProjectTime=`date +%s` # Включение секундомера для вывода времени расчёта

## Масштабирование файлов .stl
cd 0/geometry
printf 'Scaling *.stl files:\n\n' | tee ../../projectReport.txt
export FILE="inlet.stl"
surfaceTransformPoints -scale '(0.001 0.001 0.001)' $FILE $FILE | tee -a ../../projectReport.txt
export FILE="inlet.stl"
surfaceTransformPoints -translate '(0.001 0 0)' $FILE $FILE | tee -a ../../projectReport.txt
export FILE="outlet.stl"
surfaceTransformPoints -scale '(0.001 0.001 0.001)' $FILE $FILE | tee -a ../../projectReport.txt
export FILE="valve.stl"
surfaceTransformPoints -scale '(0.001 0.001 0.001)' $FILE $FILE | tee -a ../../projectReport.txt
export FILE="walls.stl"
surfaceTransformPoints -scale '(0.001 0.001 0.001)' $FILE $FILE | tee -a ../../projectReport.txt
printf 'Scaling *.stl files has being DONE.\n\n\n' | tee -a ../../projectReport.txt

## Создание и решение подпроектов по шагу клапана
printf '# Time       	average(p)\n' | tee ../../inletPatchPressures.txt # Создание файла давлений на входном сечении по шагам клапана
printf 'Solving cases by stokes:\n' | tee -a ../../projectReport.txt

stroke=$strokeStart
while [ $stroke -le $strokeEnd ]
do
	cd - # Корневая директория проекта
	printf '\n/------------------------------------Stroke = %s mm--------------------------------------/\n' $stroke
	startStrokeTime=`date +%s` # Включение секундомера для вывода времени расчёта подпроекта
	strokeMetres=`echo "scale=3; $stroke*10^(-3)" | bc -l` # Сonverting stroke to metres
	
	# Создание папки подпроекта для шага клапана и изменение под него настроек
	mkdir $stroke
	cp -a 0/* $stroke
	cd $stroke/
	sed -i "s/strokeMetres/$strokeMetres/g" solveCurrentStroke.sh 
	
	sh solveCurrentStroke.sh # Генерация сетки и поиск решения
	
	# Запись в файл давления на входном сечении
	cd - # Корневая директория проекта
	cd $stroke/case/postProcessing/patchAverage\(p,name=inlet\)/0
	tail -n1 surfaceFieldValue.dat >> ../../../../../inletPatchPressures.txt
	
	# Сохранение времени расчёта подпроекта в projectReport.txt
	cd - # Корневая директория проекта
	cd $stroke
	printf '\n  Stroke %s mm was solved in ' $stroke >> ../projectReport.txt
	endStrokeTime=`date +%s`
	solveStrokeTime=$((endStrokeTime-startStrokeTime))
	printf '%dh:%dm:%ds\n' $(($solveStrokeTime/3600)) $(($solveStrokeTime%3600/60)) $(($solveStrokeTime%60)) >> ../projectReport.txt
	
	stroke=`echo "scale=1; $stroke + $strokeDelta" |bc` # Inreasing stroke by one step
done

# Сохранение времени расчёта проекта в projectReport.txt
cd - # Корневая директория проекта
endProjectTime=`date +%s`
solveProjectTime=$((endProjectTime-startProjectTime))
printf '\n\n' >> projectReport.txt
printf '\n/---------------------------------------------------------------------------------------/' | tee -a projectReport.txt
printf '\n\n                                   ' | tee -a projectReport.txt                            
printf 'Solve time: %dh:%dm:%ds\n' $(($solveProjectTime/3600)) $(($solveProjectTime%3600/60)) $(($solveProjectTime%60)) | tee -a projectReport.txt
printf '\n/---------------------------------------------------------------------------------------/' | tee -a projectReport.txt
printf '\n\n'