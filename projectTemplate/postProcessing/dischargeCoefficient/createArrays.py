def grep_by_name(file_path, value_name):
    for grep in open(file_path):
        if value_name in grep:
            value = (re.findall('-?\ *[0-9]+\.?[0-9]*(?:[Ee]\ *-?\ *[0-9]+)?', grep))[0]

    return float(value)

# Stroke array
stroke = np.arange(STROKE_INIT,
                   STROKE_FINITE + STROKE_STEP,
                   STROKE_STEP)

# Lists
p_inlet = []
U_inlet = []
phi_inlet = []
area_inlet = []

V_c = []
L = []

valve_flow_area = []
D_n = []
mu = []

# Get data from the .dat files
for n in range(DESIGN_NO + 1):

    # Temporary design lists
    p_inlet_ = []
    U_inlet_ = []
    phi_inlet_ = []
    V_c_ = []
    L_ = []
    for h in range(len(stroke)):
        post_path = f'../../design{n}/stroke_{stroke[h]}mm/postProcessing'

        p_inlet_.append(np.loadtxt(
            f'{post_path}/patchAverage(p,static(p),total(p),mag(U),name=inlet)/0/surfaceFieldValue.dat')[1])

        U_inlet_.append(np.loadtxt(
            f'{post_path}/patchAverage(p,static(p),total(p),mag(U),name=inlet)/0/surfaceFieldValue.dat')[4])

        phi_inlet_.append(abs(np.loadtxt(
            f'{post_path}/flowRatePatch(name=inlet)/0/surfaceFieldValue.dat')[1]))

        L_.append(np.loadtxt(
            f'{post_path}/volIntegrateMagAngularMomentum(name=c0)/0/volFieldValue.dat')[1])

        V_c_.append(grep_by_name(
            f'{post_path}/volIntegrateMagAngularMomentum(name=c0)/0/volFieldValue.dat',
            'Volume'))

    # Append design lists to the project list
    p_inlet.append(np.array(p_inlet_))
    U_inlet.append(np.array(U_inlet_))
    phi_inlet.append(np.array(phi_inlet_))
    L.append(np.array(L_))
    V_c.append(np.array(V_c_))

    area_inlet.append(grep_by_name(
        f'{post_path}/flowRatePatch(name=inlet)/0/surfaceFieldValue.dat',
        'Area'))
