#!/bin/sh
# Масштабирование файлов для последующего

# ------------------------------------ Data -------------------------------- #

# Указание пути к файлам .stl для их копирования
cp -r ../../STLs/*.stl ./

# -------------------------------------------------------------------------- #


# [[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[ Script ]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]] #
export FILE="inlet.stl"
surfaceTransformPoints -scale '(0.001 0.001 0.001)' $FILE $FILE | tee scaleSTL.log
export FILE="inlet.stl"
surfaceTransformPoints -translate '(0.001 0 0)' $FILE $FILE | tee -a scaleSTL.log
export FILE="outlet.stl"
surfaceTransformPoints -scale '(0.001 0.001 0.001)' $FILE $FILE | tee -a scaleSTL.log
export FILE="valve.stl"
surfaceTransformPoints -scale '(0.001 0.001 0.001)' $FILE $FILE | tee -a scaleSTL.log
export FILE="walls.stl"
surfaceTransformPoints -scale '(0.001 0.001 0.001)' $FILE $FILE | tee -a scaleSTL.log





