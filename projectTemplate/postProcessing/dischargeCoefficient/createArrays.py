# Stroke array
stroke = np.arange(STROKE_INIT,
                   STROKE_FINITE + STROKE_STEP,
                   STROKE_STEP)

# Lists
pAreaAverage_inlet = []
phiSum_inlet = []
valveFlowArea = []
totalPressure = []
mu = []

# Get data from the .dat files
for i in range(DESIGN_NO + 1):

    # Temporary design lists
    pAreaAverage_inlet_ = []
    UAreaAverage_inlet_ = []
    phiSum_inlet_ = []
    for h in range(len(stroke)):
        post_path = f'../../design{i}/stroke_{stroke[h]}mm/postProcessing'

        pAreaAverage_inlet_.append(np.loadtxt(
            f'{post_path}/patchAverage(p,static(p),total(p),mag(U),name=inlet)/0/surfaceFieldValue.dat')[1])

        UAreaAverage_inlet_.append(np.loadtxt(
            f'{post_path}/patchAverage(p,static(p),total(p),mag(U),name=inlet)/0/surfaceFieldValue.dat')[4])

        phiSum_inlet_.append(abs(np.loadtxt(
            f'{post_path}/flowRatePatch(name=inlet)/0/surfaceFieldValue.dat')[1]))

    # Append design lists to the project list
    pAreaAverage_inlet.append(np.array(pAreaAverage_inlet_))
    UAreaAverage_inlet.append(np.array(pAreaAverage_inlet_))
    phiSum_inlet.append(np.array(phiSum_inlet_))
