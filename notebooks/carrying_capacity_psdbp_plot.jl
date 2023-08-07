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
    xlabel="Generation",
    ylabel="Population Size",
    linecolor=:grey20,
    linealpha=0.8,
    linewidth=2,
    legend=false,
    fontfamily="Times",
    titlefontsize=48,
    tickfontsize=32,
    guidefontsize=42,
    size=(3000, 1800),
    bottom_margin=28mm,
    left_margin=28mm,
    top_margin=6mm
)

p = hline!([K], linecolor=:grey, linealpha=0.4)

savefig(p, "out/carrying_capacity_psdbp_plot.pdf")

end