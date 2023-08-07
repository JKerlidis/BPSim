module CBPRandomExtinctionPlot

include("../src/BPSim.jl")

using .BPSim
using Distributions
using Random
using Plots
using Plots.PlotMeasures

seed = 98

function extinction_events(rng::AbstractRNG, z::Integer)::Int
    (z + 1) * rand(rng, Bernoulli(exp(-z / 1000)))
end

CBP_trajectory = simulate_trajectory(
    ControlFunction(extinction_events), BinomialOffspring(5, 0.2), 1; nsteps=300, seed=seed
)

p = plot(
    0:length(CBP_trajectory)-1,
    CBP_trajectory,
    xlabel="Generation",
    ylabel="Population Size",
    ylims=(0, 100),
    linecolor=:grey20,
    linealpha=0.8,
    linewidth=3,
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

p = hline!([0], linecolor=:grey, linealpha=0.4)

savefig(p, "out/cbp_random_extinction_plot.pdf")

end