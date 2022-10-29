module ZipNbTvdFigures

include("../src/BPSim.jl")

using .BPSim
using Plots
using Plots.PlotMeasures

function zip_nb_tvd_bound(z_exp::Integer, k::Integer; truncate=true)
    K = k_step_tvd_bound(k=k, z=10^z_exp, h=1, R=10.5, η=0.063, σ²=2, m=1, α=0.999)
    if truncate
        return min(K, 1)
    else
        return K
    end
end

z_exp = 1:7

one_step_bounds = zeros(Float64, length(z_exp))
for i in z_exp
    one_step_bounds[i] = zip_nb_tvd_bound(i, 1; truncate=false)
end

println(one_step_bounds)

println(k_step_tvd_bound(k=1, z=13029, h=1, R=10.5, η=0.063, σ²=2, m=1, α=0.999))
println(k_step_tvd_bound(k=1, z=13030, h=1, R=10.5, η=0.063, σ²=2, m=1, α=0.999))

end