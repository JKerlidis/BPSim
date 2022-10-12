module GWCriticalityPlot

include("src/BPSim.jl")

using .BPSim
using Plots
using Plots.PlotMeasures

seed = 98

subcritical_GW_trajectories = simulate_trajectory(PoissonOffspring(0.9), 10; nsteps=50, nreps=10, seed=seed)
critical_GW_trajectories = simulate_trajectory(PoissonOffspring(1), 10; nsteps=50, nreps=10, seed=seed)
supercritical_GW_trajectories = simulate_trajectory(PoissonOffspring(1.1), 10; nsteps=50, nreps=10, seed=seed)

function plot_trajectories(trajectories, title)
    trajectories = permutedims(trajectories)
    plot(
        0:size(trajectories)[1]-1,
        trajectories,
        title = title,
        linealpha = 0.8,
        linewidth = 3,
        legend = false,
        fontfamily = "Computer Modern",
        titlefontsize = 24,
        tickfontsize = 16
    )
end

p = plot(
    plot_trajectories(subcritical_GW_trajectories, "Subcritical (λ = 0.9)"),
    plot_trajectories(critical_GW_trajectories, "Critical (λ = 1)"),
    plot_trajectories(supercritical_GW_trajectories, "Supercritical (λ = 1.1)"),
    ylims = (0, 150),
    layout = (1, 3),
    size = (2400, 800),
    top_margin = 3mm,
    bottom_margin = 5mm,
)

display(p)

end