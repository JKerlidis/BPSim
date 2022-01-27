module BPSim

using Distributions
using Plots
using Plots.PlotMeasures
using Random
using Setfield

export
    # Functions
    sample,
    simulate_trajectory,
    plot_trajectory,

    # Abstract types
    OffspringDistribution,
    GaltonWatsonDistribution,
    PSDBPDistribution,

    # Galton-Watson offspring distributions
    BinaryOffspring,
    GeometricOffspring,
    PoissonOffspring,
    BinomialOffspring,

    # PSDBP offspring distributions
    BevertonHoltModel,
    RickerModel,
    BinaryFluctuatingKModel

include("offspring_distributions.jl")

# Simulate the trajectory of a generic branching process
function simulate_trajectory(n::Integer, ξ::OffspringDistribution, Z₀::Integer=1)
    n < 0 && throw(DomainError(n, "argument must be nonnegative"))

    rng = Xoshiro()

    Z = zeros(Int, n + 1)
    Z[1] = Z₀

    for k = 1:n, i = 1:Z[k]
        Z[k+1] += sample(rng, ξ, Z[k])
    end

    return Z
end

# Plot the trajectory of a branching process
function plot_trajectory(trajectory, K=nothing)
    p = plot(
        0:length(trajectory)-1,
        trajectory,
        xlabel = "Generation",
        ylabel = "Population Size",
        linecolor = :purple,
        linealpha = 0.8,
        legend = false,
        size = (1400, 800),
        bottom_margin = 6mm,
        left_margin = 8mm
    )

    if !isnothing(K)
        p = hline!([K], linecolor = :grey, linealpha = 0.2)
    end

    return p
end

trajectory = simulate_trajectory(
    1000,
    RickerModel()
)
# println(trajectory)
display(plot_trajectory(trajectory))

end