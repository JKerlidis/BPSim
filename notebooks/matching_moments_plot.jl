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
    title="Trajectories of a PSDBP and DCBP with matching moments",
    xlabel="Generation",
    ylabel="Population Size",
    linecolor=:purple,
    linealpha=0.6,
    linewidth=3,
    fontfamily="Computer Modern",
    titlefontsize=48,
    tickfontsize=32,
    guidefontsize=42,
    label=false,
    legend=:bottomleft,
    ylims=(0, 2000),
    size=(3200, 2000),
    bottom_margin=28mm,
    left_margin=28mm,
    top_margin=6mm
)


p = plot!(
    0:size(PSDBP_trajectory)[1]-1,
    PSDBP_trajectory,
    linecolor=:darkturquoise,
    linealpha=0.6,
    linewidth=3,
    label=false
)

# Create the legend
p = plot!(
    [-10 -20; -30 -40],
    linealpha=0.6,
    legendfontsize=32,
    linewidth=3,
    color=[:purple :darkturquoise],
    label=["DCBP trajectories" "PSDBP trajectories"]
)

savefig(p, "out/matching_moments_plot.pdf")

end