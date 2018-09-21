#!/bin/sh
# Регенерирует сетку при новом ходе клапана и находит решение

# -------------------------------------------------- Data -------------------------------------------------- #

# Задание хода клапана
stroke=-0strokeMetres

# ---------------------------------------------------------------------------------------------------------- #


# [[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[ Script ]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]] #

# Изменение хода клапана
cd mesh/
sed -i "s/strokeToReplace/$stroke/g" firstMesh.sh

# Изменение размера цилиндра для измельчения сетки под ход клапана в словаре snappyHexMeshDict
cd -
cd mesh/system
sed -i "s/strokeToReplace/$stroke/g" snappyHexMeshDict
# sed "s/strokeToReplace/$stroke/g" snappyHexMeshDictToRepl > snappyHexMeshDict

# Генерация сетки
cd -
cd mesh/
sh firstMesh.sh | tee mesh.log
checkMesh | tee -a mesh.log

# Запуск расчёта
cd -
cd case/
sh firstRun.sh | tee case.log
