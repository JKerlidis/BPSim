module ApproximateTVD

include("src/BPSim.jl")

using .BPSim
using Distributions

# trajectory = simulate_trajectory(BinaryFluctuatingKModel(100, BevertonHoltModel(500)); nsteps=10)
# display(plot_trajectory(trajectory))

p = BinomialOffspring(3, 1//2)
println(prob(p, 3))

end

