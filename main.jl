module Main

# include("src/BPSim.jl")

# using .BPSim

# trajectory = simulate_trajectory(BinaryFluctuatingKModel(100, BevertonHoltModel(500)); nsteps=10)
# display(plot_trajectory(trajectory))

h = 2
σ² = 2
η = 3
z = 0.8

σ³ = σ²^(3/2)

println(zeros(Float64, 4))

end