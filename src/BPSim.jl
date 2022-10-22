module BPSim

using Distributions
using Plots
using Plots.PlotMeasures
using Random
using Setfield

export
    # Simulations
    sample,
    prob,
    simulate_trajectory,

    # Plotting
    plot_trajectory,
    plot_trajectories,

    # Statistics
    mean,
    variance,
    std,

    # Total variation distance bounds
    one_step_tvd_bound,
    k_step_tvd_bound,

    # Abstract types
    OffspringDistribution,
    GWOffspringDistribution,
    PSDBPOffspringDistribution,

    # Galton-Watson offspring distributions
    BinaryOffspring,
    GeometricOffspring,
    PoissonOffspring,
    BinomialOffspring,

    # PSDBP offspring distributions
    BevertonHoltModel,
    RickerModel,
    BinaryFluctuatingKModel,
    ZeroOneTwoOffspring,

    # Control functions
    ControlFunction


include("offspring_distributions.jl")
include("control_functions.jl")
include("simulate.jl")
include("statistics.jl")
include("tvd_bound.jl")
include("plot.jl")

end
