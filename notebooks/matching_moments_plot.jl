module MatchingMomentsPlot

include("../src/BPSim.jl")

using .BPSim
using Random
using Plots
using Plots.PlotMeasures

seed = 99

PSDBP_trajectory = simulate_trajectory(
    ZeroOneTwoOffspring(), 1000; nsteps=300, nreps=10, seed=seed
)

CBP_trajectory = simulate_trajectory(
    ControlFunction(z -> max(z - 1, 0)), BinomialOffspring(2, 0.5), 1000; nsteps=300, nreps=10, seed=seed
)

p = plot(
    0:size(CBP_trajectory)[1]-1,
    CBP_trajectory,
    title = "Trajectories of a PSDBP and DCBP with matching moments",
    xlabel = "Generation",
    ylabel = "Population Size",
    linecolor = :purple,
    linealpha = 0.6,
    linewidth = 2,
    fontfamily = "Computer Modern",
    titlefontsize = 24,
    tickfontsize = 16,
    guidefontsize = 16,
    label = false,
    legend = :bottomleft,
    ylims = (0, 2000),
    size = (1600, 1000),
    bottom_margin = 12mm,
    left_margin = 12mm,
    top_margin = 3mm
)


p = plot!(
    0:size(PSDBP_trajectory)[1]-1,
    PSDBP_trajectory,
    linecolor = :darkturquoise,
    linealpha = 0.6,
    linewidth = 2,
    label = false
)

# Create the legend
p = plot!(
    [-10 -20; -30 -40 ],
    linealpha = 0.6,
    linewidth = 2,
    color=[:purple :darkturquoise],
    label=["DCBP trajectories" "PSDBP trajectories"]
)

display(p)

end