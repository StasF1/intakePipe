# -*- coding: utf-8 -*-
#------------------------------------------------------------------------------
# =========                 |
# \\      /  F ield         | OpenFOAM: Addition to OpenFOAM v6
#  \\    /   O peration     | Website:  https://github.com/StasF1/intakePipe
#   \\  /    A nd           | Copyright (C) 2019 Stanislau Stasheuski
#    \\/     M anipulation  |
#------------------------------------------------------------------------------
# License
#     This file is not part of OpenFOAM, but part of intakePipe – OpenFOAM
#     addition.
#
#     intakePipe is free software: you can redistribute it and/or modify it
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
#     swirlNumberFilter
#
# Description
#     Python scipt to execute it from in the ParaView using the
#     ProgrammableFilter to calculate swirl numbers for one stroke
# 
#------------------------------------------------------------------------------

piston_stroke = 91 # mm, piston stroke

phiSum_inlet = 0.0150 # kg/s, mass flow rate through inlet patch

rho = 1.205 # kg/m^3, density

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

piston_stroke *= 1e-03 # [mm] -> [m]

D_n = []
for j in range(5):
    M = (phiSum_inlet
        *inputs[j].PointData['Result']
        /inputs[j].CellData['Volume'])

    D_n.append(2*piston_stroke*M*rho
               /phiSum_inlet**2)

# Output
output.PointData.append(D_n[0], 'Whole')
output.PointData.append(D_n[1], '1st quarter')
output.PointData.append(D_n[2], '2nd quarter')
output.PointData.append(D_n[3], '3rd quarter')
output.PointData.append(D_n[4], '4th quarter')

# ***************************************************************************** #