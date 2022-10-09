module BPSim

using Distributions
using Plots
using Plots.PlotMeasures
using Random
using Setfield

export
    # Simulations
    sample,
    simulate_trajectory,
    plot_trajectory,

    # Statistics
    mean,
    variance,
    std,

    # Total variation distance bounds
    one_step_tvd_bound,
    k_step_tvd_bound,

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
include("tvd_bound.jl")
include("plot.jl")

end
