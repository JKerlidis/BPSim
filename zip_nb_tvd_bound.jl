module CalculateTVDBounds

include("src/BPSim.jl")

using .BPSim
using Plots
using Plots.PlotMeasures

k = 1:50
z_exp = 5:12

function zip_nb_tvd_bound(z_exp::Integer, k::Integer)
    min(k_step_tvd_bound(k=k, z=10^z_exp, h=1, R=44.75, η=0.063, σ²=2, m=1, α=0.999), 1)
end

p = plot(
    z_exp,
    k,
    zip_nb_tvd_bound,
    st = :surface,
    title = "TVD upper bound",
    xlabel = "\nPopulation Size",
    ylabel = "\nTrajectory Length",
    fontfamily = "Computer Modern",
    xformatter = z_exp -> "10e"*string(trunc(Int, z_exp)),
    camera = (40,50),
    titlefontsize = 24,
    tickfontsize = 16,
    guidefontsize = 16,
    size = (1800, 1200),
    top_margin = 6mm
)

display(p)

end