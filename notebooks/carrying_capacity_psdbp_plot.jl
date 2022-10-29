module CarryingCapacityPSDBPPlot

include("../src/BPSim.jl")

using .BPSim
using Plots
using Plots.PlotMeasures

seed = 98
K = 100

BH_trajectory = simulate_trajectory(BevertonHoltModel(K, BinomialOffspring(2)), 10; nsteps=1000, seed=seed)

p = plot(
    0:length(BH_trajectory)-1,
    BH_trajectory,
    title = "Trajectory of a PSDBP satisfying the Beverton-Holt model",
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
    size = (2000, 800),
    bottom_margin = 12mm,
    left_margin = 12mm,
    top_margin = 3mm
)

p = hline!([K], linecolor = :grey, linealpha = 0.2)

display(p)

end