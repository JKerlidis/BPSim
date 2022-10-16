module CalculateTVDBounds

include("src/BPSim.jl")

using .BPSim
using Plots; pyplot()
using Plots.PlotMeasures

# PyPlot.matplotlib[:rc]("font", family="serif")

k = 1:50
z_exp = 4:10

function zip_nb_tvd_bound(z_exp::Integer, k::Integer)
    min(k_step_tvd_bound(k=k, z=10^z_exp, h=1, R=10.5, η=0.063, σ²=2, m=1, α=0.999), 1)
end

p = plot(
    z_exp,
    k,
    zip_nb_tvd_bound,
    st = :surface,
    title = "TVD upper bound between DCBP and PSDBP with matching moments",
    xlabel = "\n\nPopulation Size",
    ylabel = "\n\nTrajectory Length",
    zlabel = "\nTVD",
    fontfamily = "serif",
    xformatter = z_exp -> "10e"*string(trunc(Int, z_exp)),
    xguidefontrotation = -19,
    yguidefontrotation = 47,
    camera = (30,30),
    titlefontsize = 24,
    tickfontsize = 16,
    guidefontsize = 16,
    size = (1800, 1800),
    legend = false
)

display(p)

end