# ------------------ Data ------------------ #
D = 83 # mm, diameter bore
S = 91 # mm, piston stroke
G = 0.0150 # kg/s, discharge through inlet patch
rho = 1.205 # kg/m^3, density
# ------------------------------------------ #

# [[[[[[[[[[[[[[[[[ Script ]]]]]]]]]]]]]]]]] #
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



