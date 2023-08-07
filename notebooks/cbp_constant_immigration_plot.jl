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
    xlabel="Generation",
    ylabel="Population Size",
    linecolor=:grey20,
    linealpha=0.8,
    linewidth=3,
    legend=false,
    fontfamily="Times",
    titlefontsize=48,
    tickfontsize=32,
    guidefontsize=42,
    size=(3000, 2000),
    bottom_margin=28mm,
    left_margin=28mm,
    top_margin=6mm
)

p = hline!([0], linecolor=:grey, linealpha=0.4)
p = scatter!([2], [0], markercolor="red", shape=:star4, markersize=6)


savefig(p, "out/cbp_constant_immigration_plot.pdf")

end