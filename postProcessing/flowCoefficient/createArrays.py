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
for verNo in range(1, versions + 1):

    # Create arrays for a version
    patchInletAveragePressureArray = [ ]

    flowRatePatchInletArray        = [ ]

    for h in range(0, len(stroke)):
        patchInletAveragePressureArray.append(
            np.loadtxt(
                f'../../run/ver{verNo}/{stroke[h]}/postProcessing/patchAverage(p,name=inlet)/0/surfaceFieldValue.dat'
            )[1]
        )
        flowRatePatchInletArray.append(
            abs(
                np.loadtxt(
                    f'../../run/ver{verNo}/{stroke[h]}/postProcessing/flowRatePatch(name=inlet)/0/surfaceFieldValue.dat'
                )[1]
            )
        )

    # Append array of the version to the lists
    flowRatePatchInlet.append(flowRatePatchInletArray)

    patchInletAveragePressure.append(patchInletAveragePressureArray)
