# Simulate the trajectory of a generic branching process `nreps` times
function simulate_trajectory(
    φ::ControlFunction, ξ::OffspringDistribution, Z₀::Integer=1;
    nsteps::Integer, nreps::Integer=1, seed::Integer=0
)
    nsteps < 0 && throw(DomainError(nsteps, "argument must be nonnegative"))
    nreps < 0 && throw(DomainError(nreps, "argument must be nonnegative"))

    if seed != 0
        rng = Xoshiro(seed)
    else
        rng = Xoshiro()
    end

    Z = zeros(Int, nreps, nsteps + 1)

    for rep = 1:nreps
        Z[rep, 1] = Z₀
        for step = 1:nsteps
            pop_size = sample(rng, φ, Z[rep, step])
            for i = 1:pop_size
                Z[rep, step+1] += sample(rng, ξ, Z[rep, step])
            end
        end
    end

    return permutedims(Z)
end

function simulate_trajectory(
    ξ::OffspringDistribution, Z₀::Integer=1; nsteps::Integer, nreps::Integer=1, seed::Integer=0
)
    φ = ControlFunction()
    simulate_trajectory(φ, ξ, Z₀; nsteps=nsteps, nreps=nreps, seed=seed)
end