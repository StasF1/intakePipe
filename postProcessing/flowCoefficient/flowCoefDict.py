#----------------------------------*-py-*--------------------------------------
# =========                 |
# \\      /  F ield         | OpenFOAM: Addition to OpenFOAM v6
#  \\    /   O peration     | Website:  https://github.com/StasF1/intakePipe
#   \\  /    A nd           | Copyright (C) 2018 Stanislau Stasheuski
#    \\/     M anipulation  |
#------------------------------------------------------------------------------

exec(open('../../run/./intakePipeDict').read())

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #

#- Boundary conditions
F_inlet = 0.000840365 # square metres, version one #TODO get area from the surfaceFieldValue.dat file

u_Ver1 = 15 # m/s, inlet speed for version one
u_Ver2 = 12.1409 # m/s, inlet speed for version two
u_Ver3 = 9.9852 # m/s, inlet speed for version three

#- Intake air/gas
ro_gas = 1.205 # kg/m^3
p_atm = 101325 # Pa, atmospheric pressure

#- Pipe geometry (watch the picture)
d_pipe = 25.688 # mm, the minimum diameter of intake pipe (or diameter for the A point)
d_2Pipe = 29.756 # mm, chamfer diameter of valve neck (or diameter for the A1 point)

#- Valve geometry (watch the picture)
d_bar = 6.96 # mm, bar diameter ( d_c )
d_1 = 26.782 # mm, valve diameter ( d_1 )
d_2 = 29.206 # mm, head valve diameter ( d_2 )
teta = 45 # valve chamfer angle

# *************************************************************************** #
