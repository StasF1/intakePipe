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
#     Allrun
#
# Description
#     Cкрипт запускающий расчёт для всех вариантов геометрии канала
#
#------------------------------------------------------------------------------

source intakePipeDict.sh

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

startProjectTime=`date +%s`

for (( verNo = 1; verNo <= $versions; verNo++ )); do
	cd version$verNo/
		
	# Copying 0/ folder & main script from the version №1 to the other versions 
	if [[ $verNo>1 ]]; then
		cp -r ../version1/*.sh ./
		cp -r ../version1/0 ./
		rm -r 0/geometry/*.stl
		printf '\n'
	fi
	printf 'Running solveVersion.sh on %s\n' ${PWD}
	bash check.sh
	# bash solveVersion.sh
	cd ../
done

endProjectTime=`date +%s`
projectTime=$((endProjectTime-startProjectTime))
printf 'All versions have being solved in %dh:%dm:%ds\n'\
	 $(($projectTime/3600)) $(($projectTime%3600/60)) $(($projectTime%60))

# ***************************************************************************** #



