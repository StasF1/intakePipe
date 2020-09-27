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
import re
import numpy as np
import matplotlib.pyplot as plt

from math import pi

exec(open("../.././projectDict").read())
exec(open("./createArrays.py").read())
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

sind = lambda x : np.sin(np.deg2rad(x))
cosd = lambda x : np.cos(np.deg2rad(x))
tand = lambda x : np.tan(np.deg2rad(x))

#- Convert data to metres
PISTON_STROKE *= 1e-3
PISTON_BORE *= 1e-3
D_PIPE *= 1e-3
D_2PIPE *= 1e-3
D_1 *= 1e-3
D_2 *= 1e-3
D_BAR *= 1e-3
stroke = stroke*1e-3

# Minimal inlet area
# ~~~~~~~~~~~~~~~~~~
#- Critical cuts
h_crI = (D_PIPE - D_1)/sind(2*THETA)
h_crII = (D_2PIPE - D_1)/sind(2*THETA)

#- Minimal pipe area
critical_area = pi*D_PIPE**2/4 - pi*D_BAR**2/4

for h in range(len(stroke)):
    if (stroke[h] <= h_crI):
        ''' Cut I '''
        cut='I'
        valve_flow_area.append(
            pi*stroke[h]
            *cosd(THETA)
            *(D_PIPE - stroke[h]*sind(THETA)*cosd(THETA)))

    elif (stroke[h] > h_crI) and (stroke[h] <= h_crII):
        ''' Cut II '''
        cut='II'
        valve_flow_area.append(
            pi*stroke[h]
            *cosd(THETA)
            *(D_1 + stroke[h]*sind(THETA)*cosd(THETA)))

    else:
        ''' Cut III '''
        cut='III'
        valve_flow_area.append(
            pi/4
            *(D_2PIPE + D_1)
            *np.sqrt(pow(D_2PIPE - D_1, 2)
                     + pow(2*stroke[h] - (D_2PIPE - D_1)*tand(THETA), 2)))

    print(f'Cut type for stroke {int(stroke[h]*1e+03)} mm: {cut}')

    if (valve_flow_area[h] > critical_area):
        valve_flow_area[h] = critical_area


# Discharge coefficient
# ~~~~~~~~~~~~~~~~~~~~~
plt.figure().suptitle('Discharge coefficient',
                      fontweight='bold',
                      fontsize=14)

for n in range(DESIGN_NO + 1):
    mu.append(phi_inlet[n]
              /valve_flow_area
              /np.sqrt(2*p_inlet[n] + U_inlet[n]**2))

    plt.plot(stroke*1e+3,
             mu[n],
             linewidth=2,
             label=f'design{n}')

plt.grid(True)
plt.legend(loc='best', fontsize=12)
plt.xlabel('Stroke, mm', fontsize=12)
plt.ylabel('$\mu$', fontsize=12)

plt.savefig('../mu.png')


# Swirl number
# ~~~~~~~~~~~~
plt.figure().suptitle('Swirl number',
                      fontweight='bold',
                      fontsize=14)

for n in range(DESIGN_NO + 1):
    D_n.append(2*PISTON_STROKE*rhoInf*L[n]
               /phi_inlet[n]/V_c[n])

    plt.plot(stroke*1e+3,
             pi/2*PISTON_BORE/PISTON_STROKE*D_n[n],
             linewidth=2,
             label=f'design{n}')

plt.grid(True)
plt.legend(loc='best', fontsize=12)
plt.xlabel('Stroke, mm', fontsize=12)
plt.ylabel('$D_c$', fontsize=12)

plt.savefig('../D_n.png')

# exit(plt.show())

# -----------------------------------------------------------------------------