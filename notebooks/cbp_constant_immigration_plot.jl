module CarryingCapacityPSDBPPlot

include("../src/BPSim.jl")

using .BPSim
using Plots
using Plots.PlotMeasures

seed = 98

CBP_trajectory = simulate_trajectory(
    ControlFunction(z -> z + 1), BinaryOffspring(), 3; nsteps=50, seed=seed
)

p = plot(
    0:length(CBP_trajectory)-1,
    CBP_trajectory,
    title = "Trajectory of a CBP with a constant rate of immigration",
    xlabel = "Generation",
    ylabel = "Population Size",
    linecolor = :purple,
    linealpha = 0.8,
    linewidth = 2,
    legend = false,
    fontfamily = "Computer Modern",
    titlefontsize = 24,
    tickfontsize = 16,
    guidefontsize = 16,
    size = (1400, 1000),
    bottom_margin = 12mm,
    left_margin = 12mm,
    top_margin = 3mm
)

p = hline!([0], linecolor = :grey, linealpha = 0.2)
p = scatter!([2], [0], markercolor = "red", shape=:star4, markersize = 6)


display(p)

end