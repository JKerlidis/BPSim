# Simulate the trajectory of a generic branching process `nreps` times
function simulate_trajectory(ξ::OffspringDistribution, Z₀::Integer=1; nsteps::Integer, nreps::Integer=1)
    nsteps < 0 && throw(DomainError(nsteps, "argument must be nonnegative"))
    nreps < 0 && throw(DomainError(nreps, "argument must be nonnegative"))

    rng = Xoshiro()

    Z = zeros(Int, nreps, nsteps + 1)

    for rep = 1:nreps
        Z[rep, 1] = Z₀
        for step = 1:nsteps, i = 1:Z[rep, step]
            Z[rep, step+1] += sample(rng, ξ, Z[rep, step])
        end
    end

    return Z
end
