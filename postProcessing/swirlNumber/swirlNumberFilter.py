# -*- coding: utf-8 -*-
#------------------------------------------------------------------------------
# =========                 |
# \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox
#  \\    /   O peration     | Website:  https://github.com/StasF1
#   \\  /    A nd           | Copyright (C) 2017 OpenFOAM Foundation
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
#     swirlNumberFilter
#
# Description
#     Python scipt to execute it from in the ParaView using the
#     ProgrammableFilter to calculate swirl numbers for one stroke
# 
#------------------------------------------------------------------------------

D   = 83 # mm, diameter bore

S   = 91 # mm, piston stroke

G   = 0.0150 # kg/s, discharge through inlet patch

rho = 1.205 # kg/m^3, density

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

# Calculation swirl numbers
D = D*1e-03 # mm -> m
S = S*1e-03 # mm -> m
D_n = []
for i in range(0, 5):
    M = G*inputs[i].PointData['Result']/inputs[i].CellData['Volume']
    D_n.append( 2*S*M*rho/pow(G, 2) )
        
# Output
output.PointData.append(D_n[0], 'Whole')
output.PointData.append(D_n[1], '1st quarter')
output.PointData.append(D_n[2], '2nd quarter')
output.PointData.append(D_n[3], '3rd quarter')
output.PointData.append(D_n[4], '4th quarter')

# ***************************************************************************** #

