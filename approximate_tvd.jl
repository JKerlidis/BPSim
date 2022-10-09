module ApproximateTVD

using Decimals
using Distributions

# trajectory = simulate_trajectory(BinaryFluctuatingKModel(100, BevertonHoltModel(500)); nsteps=10)
# display(plot_trajectory(trajectory))

p = Binomial(3, 1//2)
println(typeof(pdf(p, 3)))

end

