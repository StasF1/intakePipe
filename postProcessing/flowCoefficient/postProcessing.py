#!/usr/bin/env python3
#-----------------------------------------------------------------------------
# =========                 |
# \\      /  F ield         | OpenFOAM: Addition to OpenFOAM v6
#  \\    /   O peration     | Website:  https://github.com/StasF1/intakePipe
#   \\  /    A nd           | Copyright (C) 2018 Stanislau Stasheuski
#    \\/     M anipulation  |
#------------------------------------------------------------------------------
# License
#     This file is not part of OpenFOAM, but part of intakePipe – OpenFOAM
#     addition.
#
#     intakePipe (like OpenFOAM) is free software: you can redistribute it 
#     and/or modify it under the terms of the GNU General Public License as
#     published by the Free Software Foundation, either version 3 of the License,
#     or (at your option) any later version.
#
#     intakePipe (like OpenFOAM) is distributed in the hope that it will be
#     useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#     See the GNU General Public License for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with this repository. If not, see <http://www.gnu.org/licenses/>
#
# File
#     postProcessing.py
#
# Description
#     Calculates flow coefficient for different valve strokes
#
#------------------------------------------------------------------------------

from __future__ import division
import numpy as np
# import math #, glob, os, shutil

# import matplotlib.pyplot as plt

from math import sqrt, pi
sind = lambda x : np.sin( np.deg2rad(x) )
cosd = lambda x : np.cos( np.deg2rad(x) )
tand = lambda x : np.tan( np.deg2rad(x) )

from flowCoefDict import *

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

exec(open("./createArrays.py").read())

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

# Get data from the .dat files
for verNo in range(1, versions + 1):
    
    # Create average pressure array for a version
    patchInletAveragePressureArray = []
    for h in range(0, len(stroke)):
        patchInletAveragePressureArray.append(
            np.loadtxt(
                f'../../run/ver{verNo}/{stroke[h]}/postProcessing/patchAverage(p,name=inlet)/0/surfaceFieldValue.dat'
            )[1]
        )
    
    # Append array of the version to the list
    patchInletAveragePressure.append(patchInletAveragePressureArray)

# Calculating minimal intake area
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#- Converting data to metres
d_pipe  = d_pipe *1e-03
d_2Pipe = d_2Pipe*1e-03
d_1     = d_1    *1e-03
d_2     = d_2    *1e-03
d_bar   = d_bar  *1e-03
stroke  = stroke *1e-03 #(!)

#- Critical cuts
h_crI = (
    (d_pipe - d_1)/sind(2*teta)
)
h_crII = (
    (d_2Pipe - d_1)/sind(2*teta)
)

#- Minimum pipe area 
criticalArea = (
    pi*pow(d_pipe, 2)/4 - pi*pow(d_bar, 2)/4
)

for i in range(0, len(stroke)):
    if ( stroke[i] <= h_crI ): # cut I
        print(f'Stroke {int(stroke[i]*1e+03)} mm: cut I')
        valveFlowArea.append(
            pi*stroke[i]*cosd(teta)*( d_pipe - stroke[i]*sind(teta)*cosd(teta) )
        )

    elif (stroke[i] > h_crI) & (stroke[i] <= h_crII): # cut II
        print(f'Stroke {int(stroke[i]*1e+03)} mm: cut II')
        valveFlowArea.append(
            pi*stroke[i]*cosd(teta)*( d_1 + stroke[i]*sind(teta)*cosd(teta) )
        )

    else: # cut III
        print(f'Stroke {int(stroke[i]*1e+03)} mm: cut III')
        valveFlowArea.append(
            pi/4*(d_2Pipe + d_1)*sqrt( pow(d_2Pipe - d_1, 2) + pow(2*stroke[i] - (d_2Pipe - d_1)*tand(teta), 2) )
        )

    if (valveFlowArea[i] > criticalArea):    valveFlowArea[i] = criticalArea


# ## Calculating flow coefficients
# #  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# G = ro_gas*F_inlet*u_Ver1;
#
# muVer1 = flowCoef(u_Ver1, G, h, valveFlowArea, p_inletVer1);
# muVer2 = flowCoef(u_Ver2, G, h, valveFlowArea, p_inletVer2);
# muVer3 = flowCoef(u_Ver2, G, h, valveFlowArea, p_inletVer3);
#
# for i = 1:len(h)
#     mufVer1(i) = muVer1(i)*valveFlowArea(i);
#     mufVer2(i) = muVer2(i)*valveFlowArea(i);
#     mufVer3(i) = muVer3(i)*valveFlowArea(i);
# end

# -----------------------------------------------------------------------------
