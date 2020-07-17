#!/usr/bin/env python3
'''--------------------------------------------------------------------------
=========                 |
\\      /  F ield         | OpenFOAM: Addition to OpenFOAM v6
 \\    /   O peration     | Website:  https://github.com/StasF1/intakePipe
  \\  /    A nd           | Copyright (C) 2018-2020 Stanislau Stasheuski
   \\/     M anipulation  |
------------------------------------------------------------------------------
License
    This file is not part of OpenFOAM, but part of intakePipe – OpenFOAM
    addition.

    intakePipe (like OpenFOAM) is free software: you can redistribute it
    and/or modify it under the terms of the GNU General Public License as
    published by the Free Software Foundation, either version 3 of the License,
    or (at your option) any later version.

    intakePipe (like OpenFOAM) is distributed in the hope that it will be
    useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
    See the GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this repository. If not, see <http://www.gnu.org/licenses/>

File
    dischargeCoefficient.py

Description
    Calculate flow coefficient for different valve strokes

---------------------------------------------------------------------------'''
from math import pi
import numpy as np
import matplotlib.pyplot as plt

exec(open("../.././projectDict").read())
exec(open("./createArrays.py").read())
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

sind = lambda x : np.sin(np.deg2rad(x))
cosd = lambda x : np.cos(np.deg2rad(x))
tand = lambda x : np.tan(np.deg2rad(x))

# Calculating minimal intake area
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#- Converting data to metres
d_pipe *= 1e-3
d_2Pipe *= 1e-3
d_1 *= 1e-3
d_2 *= 1e-3
d_bar *= 1e-3
stroke = stroke*1e-3

#- Critical cuts
h_crI = (d_pipe - d_1)/sind(2*theta)
h_crII = (d_2Pipe - d_1)/sind(2*theta)

#- Minimum pipe area 
criticalArea = pi*d_pipe**2/4 - pi*d_bar**2/4

for i in range(len(stroke)):
    if (stroke[i] <= h_crI):
        ''' Cut I '''
        cut='I'
        valveFlowArea.append(
            pi*stroke[i]
            *cosd(theta)
            *(d_pipe - stroke[i]*sind(theta)*cosd(theta)))

    elif (stroke[i] > h_crI) and (stroke[i] <= h_crII):
        ''' Cut II '''
        cut='II'
        valveFlowArea.append(
            pi*stroke[i]
            *cosd(theta)
            *(d_1 + stroke[i]*sind(theta)*cosd(theta)))

    else:
        ''' Cut III '''
        cut='III'
        valveFlowArea.append(
            pi/4
            *(d_2Pipe + d_1)
            *np.sqrt(pow(d_2Pipe - d_1, 2)
                     + pow(2*stroke[i] - (d_2Pipe - d_1)*tand(theta), 2)))

    print(f'Cut type for stroke {int(stroke[i]*1e+03)} mm: {cut}')

    if (valveFlowArea[i] > criticalArea):
        valveFlowArea[i] = criticalArea


# Calculating flow coefficients
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
plt.figure().suptitle('Discharge coefficient',
                      fontweight='bold',
                      fontsize=14)

for i in range(DESIGN_NO + 1):
    deltaP = pAreaAverage_inlet[i] + UAreaAverage_inlet[i]**2/2

    mu.append(phiSum_inlet[i]
              /valveFlowArea
              /np.sqrt(2*deltaP))

    plt.plot(stroke*1e+3,
             mu[i],
             linewidth=2,
             label=f'design{i}')

plt.grid(True)
plt.legend(loc='best', fontsize=12)
plt.xlabel('Stroke, mm', fontsize=12)
plt.ylabel('$\mu$', fontsize=12)

plt.savefig('../mu.png')

# exit(plt.show())

# -----------------------------------------------------------------------------