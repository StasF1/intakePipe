#!/bin/sh
# Регенерирует сетку при новом ходе клапана и находит решение

# ------------------------------------- Data ------------------------------------- #

# Задание хода клапана
stroke=-0strokeMetres

# -------------------------------------------------------------------------------- #


# [[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[ Script ]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]] #

# Изменение хода клапана
cd mesh/
sed -i "s/strokeToReplace/$stroke/g" firstMesh.sh

# Изменение размера цилиндра для измельчения сетки под ход клапана в словаре snappyHexMeshDict
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
