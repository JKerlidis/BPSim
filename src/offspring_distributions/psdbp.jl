"""
    BevertonHoltModel(K, base_distribution)

A *Beverton-Holt (BH) model* taking observations from a specified GaltonWatsonDistribution object:

```math
m(z) = \\frac{2K}{K + z}, \\quad K > 0.
```

Methods:
```julia
    BevertonHoltModel(K, base_distribution) # Beverton-Holt model on base_distribution with carrying capacity K
    BevertonHoltModel(K)                    # Binary splitting Beverton-Holt model with carrying capacity K
    BevertonHoltModel(base_distribution)    # Beverton-Holt model on base_distribution with K=100
    BevertonHoltModel()                     # Binary splitting Beverton-Holt model with K=100

    sample([rng,] ξ, z)                     # Sample from the model, given the current population size
```
"""
struct BevertonHoltModel{T<:GaltonWatsonDistribution} <: PSDBPDistribution
    K::Int
    base_distribution::T
    function BevertonHoltModel{T}(K::Int, base_distribution) where {T<:GaltonWatsonDistribution}
        K > 0 || throw(DomainError(K, "argument must be a positive integer"))
        new(K, base_distribution)
    end
end

function BevertonHoltModel(K::Int, base_distribution::T) where {T<:GaltonWatsonDistribution}
    BevertonHoltModel{T}(K, base_distribution)
end
function BevertonHoltModel(K::Int)
    BevertonHoltModel(K, BinaryOffspring())
end
function BevertonHoltModel(base_distribution::T) where {T<:GaltonWatsonDistribution}
    BevertonHoltModel(100, base_distribution)
end
function BevertonHoltModel()
    BevertonHoltModel(100, BinaryOffspring())
end

function sample(rng::AbstractRNG, ξ::BevertonHoltModel{<:BinaryOffspring}, z::Integer)::Int
    p = ξ.K // (ξ.K + z)
    sample(rng, BinaryOffspring(p))
end
function sample(rng::AbstractRNG, ξ::BevertonHoltModel{<:GeometricOffspring}, z::Integer)::Int
    p = (ξ.K + z) // (3*ξ.K + z)
    sample(rng, GeometricOffspring(p))
end
function sample(rng::AbstractRNG, ξ::BevertonHoltModel{<:PoissonOffspring}, z::Integer)::Int
    λ = (2*ξ.K) // (ξ.K + z)
    sample(rng, PoissonOffspring(λ))
end
function sample(rng::AbstractRNG, ξ::BevertonHoltModel{<:BinomialOffspring}, z::Integer)::Int
    p = (2*ξ.K) // (ξ.base_distribution.n * (ξ.K + z))
    sample(rng, BinomialOffspring(ξ.base_distribution.n, p))
end


"""
    RickerModel(K, r, base_distribution)

A *Ricker model* taking observations from a specified GaltonWatsonDistribution object:

```math
m(z) = r^{1 - \frac{z}{K}}, \\quad r > 1, \\; K > 0.
```

Methods:
```julia
    RickerModel(K, r, base_distribution)    # Ricker model on base_distribution with carrying capacity K and rate r
    RickerModel(K, r)                       # Binary splitting Ricker model with carrying capacity K and rate r
    RickerModel(K, base_distribution)       # Ricker model on base_distribution with carrying capacity K and r=2
    RickerModel(K)                          # Binary splitting Ricker model with carrying capacity K and r=2
    RickerModel(base_distribution)          # Ricker model on base_distribution with K=100 and r=2
    RickerModel()                           # Binary splitting Ricker model with K=100 and r=2

    sample([rng,] ξ. z)                     # Sample from the model, given the current population size
```
"""
struct RickerModel{T<:Real, S<:GaltonWatsonDistribution} <: PSDBPDistribution
    K::Int
    r::T
    base_distribution::S
    function RickerModel{T,S}(K::Int, r, base_distribution) where {T<:Real, S<:GaltonWatsonDistribution}
        K > 0 || throw(DomainError(K, "argument must be a positive integer"))
        r > one(r) || throw(DomainError(r, "argument must be in the range (1,∞)"))
        new(K, r, base_distribution)
    end
end

function RickerModel(K::Int, r::T, base_distribution::S) where {T<:Real, S <:GaltonWatsonDistribution}
    RickerModel{T,S}(K, r, base_distribution)
end
function RickerModel(K::Int, r::T) where {T<:Real}
    RickerModel(K, r, BinaryOffspring())
end
function RickerModel(K::Int, base_distribution::S) where {S<:GaltonWatsonDistribution}
    RickerModel(K, 2, base_distribution)
end
function RickerModel(K::Int)
    RickerModel(K, 2, BinaryOffspring())
end
function RickerModel(base_distribution::S) where {S<:GaltonWatsonDistribution}
    RickerModel(100, 2, base_distribution)
end
function RickerModel()
    RickerModel(100, 2, BinaryOffspring())
end

function sample(rng::AbstractRNG, ξ::RickerModel{<:Real, <:BinaryOffspring}, z::Integer)::Int
    p = ξ.r^(1 - z/ξ.K) / 2
    sample(rng, BinaryOffspring(p))
end
function sample(rng::AbstractRNG, ξ::RickerModel{<:Real, <:GeometricOffspring}, z::Integer)::Int
    p = 1 / (ξ.r^(z/ξ.K - 1) + 1)
    sample(rng, GeometricOffspring(p))
end
function sample(rng::AbstractRNG, ξ::RickerModel{<:Real, <:PoissonOffspring}, z::Integer)::Int
    λ = ξ.r^(1 - z/ξ.K)
    sample(rng, PoissonOffspring(λ))
end
function sample(rng::AbstractRNG, ξ::RickerModel{<:Real, <:BinomialOffspring}, z::Integer)::Int
    p = ξ.r^(1 - z/ξ.K) / ξ.base_distribution.n
    sample(rng, BinomialOffspring(ξ.base_distribution.n, p))
end


"""
    BinaryFluctuatingKModel(β, base_distribution)

A *binary fluctuating carrying capacity model* over an underlying PSDBPDistribution object.
With equal chance, the model will return an observation from the underlying PSDBP with K
either increased or decreased by a factor of β. As an example, the following would result
for an underlying Beverton-Holt model:

```math
m(z) = \\begin{cases}
    \\frac{2}{1 + z/βK} & w.p. \\frac{1}{2} \\\\
    \\frac{2}{1 + zβ/K} & w.p. \\frac{1}{2}
\\end{cases}, \\quad β > 0.
```

Methods:
```julia
    BinaryFluctuatingKModel(β, psdbp_distribution)  # Binary fluctuations of factor β over psdbp_distribution
    BinaryFluctuatingKModel(psdbp_distribution)     # Binary fluctuations of factor 1.25 over psdbp_distribution
    BinaryFluctuatingKModel(β)                      # Binary fluctuations of factor β over a BH model
    BinaryFluctuatingKModel()                       # Binary fluctuations of factor 1.25 over a BH model

    sample([rng,] ξ, z)                             # Sample from the model, given the current population size
```
"""
struct BinaryFluctuatingKModel{T<:Real, S<:PSDBPDistribution} <: PSDBPDistribution
    β::T
    psdbp_distribution::S
    function BinaryFluctuatingKModel{T,S}(β, psdbp_distribution) where {T<:Real, S<:PSDBPDistribution}
        β > zero(β) || throw(DomainError(β, "argument must be in the range (0,∞)"))
        if !hasfield(typeof(psdbp_distribution), :K)
            throw(ArgumentError("the given psdbp_distribution does not have a 'K' field"))
        end
        new(β, psdbp_distribution)
    end
end

function BinaryFluctuatingKModel(β::T, psdbp_distribution::S) where {T<:Real, S<:PSDBPDistribution}
    BinaryFluctuatingKModel{T,S}(β, psdbp_distribution)
end
function BinaryFluctuatingKModel(psdbp_distribution::S) where {S<:PSDBPDistribution}
    BinaryFluctuatingKModel(5//4, psdbp_distribution)
end
function BinaryFluctuatingKModel(β::T) where {T<:Real}
    BinaryFluctuatingKModel(β, BevertonHoltModel())
end
function BinaryFluctuatingKModel()
    BinaryFluctuatingKModel(5//4, BevertonHoltModel())
end

function sample(rng::AbstractRNG, ξ::BinaryFluctuatingKModel, z::Integer)::Int
    if rand(rng) > 0.5
        updated_K = round(Int, ξ.psdbp_distribution.K * ξ.β)
    else
        updated_K = round(Int, ξ.psdbp_distribution.K / ξ.β)
    end

    psdbp_distribution = ξ.psdbp_distribution
    psdbp_distribution = @set psdbp_distribution.K = updated_K
    sample(rng, psdbp_distribution, z)
end