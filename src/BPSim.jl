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

    # Statistics
    mean,
    variance,
    std,

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
include("simulate.jl")
include("statistics.jl")


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

end
