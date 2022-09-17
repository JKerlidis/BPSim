module Main

include("src/BPSim.jl")

using .BPSim


trajectory = simulate_trajectory(BevertonHoltModel(500); nsteps=10)
println(trajectory)
# display(plot_trajectory(trajectory))

end