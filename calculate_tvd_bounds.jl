module CalculateTVDBounds

include("src/BPSim.jl")

using .BPSim

max_index = 10

# Subcritical process
subcritical_z_bounds = zeros(Float64, max_index, max_index)
for k = 1:max_index, i = 1:max_index
    z = 10^i
    bound = k_step_tvd_bound(k=k, z=z, h=0.1, R=40, η=0.1, σ²=4, m=2, α=0.5)
    subcritical_z_bounds[k,i] = bound
end
println("Subcritical process")
display(subcritical_z_bounds)
println()

# Supercritical process
supercritical_z_bounds = zeros(Float64, max_index, max_index)
for k = 1:max_index, i = 1:max_index
    z = 10^i
    bound = k_step_tvd_bound(k=k, z=z, h=2.5, R=40, η=0.1, σ²=4, m=1, α=0.5)
    supercritical_z_bounds[k,i] = bound
end
println("Supercritical process")
display(supercritical_z_bounds)

end
