module CBPRandomExtinctionPlot

include("src/BPSim.jl")

using .BPSim
using Distributions
using Random
using Plots
using Plots.PlotMeasures

seed = 98

function extinction_events(rng::AbstractRNG, z::Integer)::Int
    p = z == 0 ? 1 : exp((1-z)/1000)
    (z + 1) * rand(rng, Bernoulli(p))
end

CBP_trajectory = simulate_trajectory(
    ControlFunction(extinction_events), BinomialOffspring(5, 0.2), 1; nsteps=300, seed=seed
)

p = plot(
    0:length(CBP_trajectory)-1,
    CBP_trajectory,
    title = "Trajectory of a CBP with immigration and random extinction events",
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

display(p)

end