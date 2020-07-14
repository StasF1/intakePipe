# Stroke array
stroke = np.arange(
    strokeStart,
    strokeEnd + strokeDelta,
    strokeDelta
)

# Lists
patchInletAveragePressure = [ ]

flowRatePatchInlet        = [ ]

valveFlowArea             = [ ]

pressureDifference        = [ ]

mu                        = [ ]

# Get data from the .dat files
for i in range(designNo):

    # Create arrays for a version
    patchInletAveragePressureArray = [ ]

    flowRatePatchInletArray        = [ ]

    for h in range(0, len(stroke)):
        patchInletAveragePressureArray.append(
            np.loadtxt(
                f'../../run/design{i}/{stroke[h]}/postProcessing/patchAverage(p,name=inlet)/0/surfaceFieldValue.dat')[1])

        flowRatePatchInletArray.append(
            abs(np.loadtxt(
                f'../../run/design{i}/{stroke[h]}/postProcessing/flowRatePatch(name=inlet)/0/surfaceFieldValue.dat')[1]))

    # Append array of the version to the lists
    flowRatePatchInlet.append(np.array(flowRatePatchInletArray))

    patchInletAveragePressure.append(np.array(patchInletAveragePressureArray))
