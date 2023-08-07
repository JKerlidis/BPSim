module CarryingCapacityComparativePlot

include("../src/BPSim.jl")

using .BPSim
using Random
using Distributions
using Plots
using Plots.PlotMeasures

seed = 98
nsteps = 300
K = 300
M = 2
λ = 3

PSDBP_trajectory = simulate_trajectory(BevertonHoltModel(K, BinomialOffspring(2)), 1; nsteps=nsteps, seed=seed)
φ(rng::AbstractRNG, z::Integer) = z == 0 ? 0 : rand(rng, Binomial(z + M, 2 * K^2 / (λ * (K + M) * (z + K))))
CBP_trajectory = simulate_trajectory(ControlFunction(φ), PoissonOffspring(λ), 1; nsteps=nsteps, seed=seed)

p = plot(
    0:nsteps,
    PSDBP_trajectory,
    xlabel="Generation",
    ylabel="Population Size",
    linecolor=:lightseagreen,
    linealpha=0.8,
    linewidth=3,
    legend=:bottomright,
    label="PSDBP",
    fontfamily="Times",
    titlefontsize=48,
    tickfontsize=32,
    guidefontsize=42,
    size=(3000, 1800),
    bottom_margin=28mm,
    left_margin=28mm,
    top_margin=6mm
)

p = plot!(
    0:nsteps,
    CBP_trajectory,
    linecolor=:purple,
    linealpha=0.6,
    linewidth=3,
    label="CBP",
)

p = hline!(
    [K],
    linecolor=:grey,
    linealpha=0.4,
    label=false,
    legendfontsize=32,
)

savefig(p, "out/carrying_capacity_comparative_plot.pdf")

end