"""
    BinaryOffspring(p)

A *binary splitting offspring distribution* with:

```math
P(ξ = 0) = 1-p, \\quad P(ξ = 2) = p,  \\quad p \\in [0,1].
```

Methods:
```julia
    BinaryOffspring(p)      # Binary splitting distribution with reproduction probability p
    BinaryOffspring()       # Binary splitting distribution with p=2/3

    sample([rng,] ξ)        # Sample a random observation from the distribution
    mean(ξ)                 # Get the distribution mean
    variance(ξ)             # Get the distribution variance
```
"""
struct BinaryOffspring{T<:Real} <: GaltonWatsonDistribution
    p::T
    function BinaryOffspring{T}(p) where {T<:Real}
        zero(p) <= p <= one(p) || throw(DomainError(p, "argument must be in the range [0,1]"))
        new(p)
    end
end

BinaryOffspring(p::T) where {T<:Real} = BinaryOffspring{T}(p)
BinaryOffspring() = BinaryOffspring(2//3)

function sample(rng::AbstractRNG, ξ::BinaryOffspring)::Int
    rand(rng) > ξ.p ? 0 : 2
end
mean(ξ::BinaryOffspring) = 2*ξ.p
variance(ξ::BinaryOffspring) = 4*ξ.p - (2*ξ.p)^2


"""
    GeometricOffspring(p)

A *geometric offspring distribution* with:

```math
P(ξ = k) = (1-p)^k p,  \\quad p \\in [0,1].
```

Methods:
```julia
    GeometricOffspring(p)   # Geometric distribution with probability of success p
    GeometricOffspring()    # Geometric distribution with p=1/2

    sample([rng,] ξ)        # Sample a random observation from the distribution
    mean(ξ)                 # Get the distribution mean
    variance(ξ)             # Get the distribution variance
```
"""
struct GeometricOffspring{T<:Real} <: GaltonWatsonDistribution
    p::T
    function GeometricOffspring{T}(p) where {T<:Real}
        zero(p) < p <= one(p) || throw(DomainError(p, "argument must be in the range (0,1]"))
        new(p)
    end
end

GeometricOffspring(p::T) where {T<:Real} = GeometricOffspring{T}(p)
GeometricOffspring() = GeometricOffspring(1//2)

function sample(rng::AbstractRNG, ξ::GeometricOffspring)::Int
    floor(Int, log(rand(rng)) / log(1 - ξ.p))
end
mean(ξ::GeometricOffspring) = (1 - ξ.p) // ξ.p
variance(ξ::GeometricOffspring) = (1 - ξ.p) // ξ.p^2


"""
    PoissonOffspring(λ)

A *Poisson offspring distribution* with:

```math
P(ξ = k) = \\frac{λ^k e^{-λ}}{k!},  \\quad λ \\in [0,∞).
```

Methods:
```julia
    PoissonOffspring(λ)     # Poisson distribution with rate parameter λ
    PoissonOffspring()      # Poisson distribution with λ=1

    sample([rng,] ξ)        # Sample a random observation from the distribution
    mean(ξ)                 # Get the distribution mean
    variance(ξ)             # Get the distribution variance
```
"""
struct PoissonOffspring{T<:Real} <: GaltonWatsonDistribution
    λ::T
    function PoissonOffspring{T}(λ) where {T<:Real}
        λ >= zero(λ) || throw(DomainError(λ, "argument must be in the range [0,∞)"))
        new(λ)
    end
end

PoissonOffspring(λ::T) where {T<:Real} = PoissonOffspring{T}(λ)
PoissonOffspring() = PoissonOffspring(1)

function sample(rng::AbstractRNG, ξ::PoissonOffspring)::Int
    rand(rng, Poisson(ξ.λ))
end
mean(ξ::PoissonOffspring) = ξ.λ
variance(ξ::PoissonOffspring) = ξ.λ


"""
    BinomialOffspring(n, p)

A *binomial offspring distribution* with:

```math
P(ξ = k) = {n \\choose k}p^k(1-p)^{n-k},  \\quad n \\in 0,1,2,\\ldots, \\; p \\in [0,1].
```

Methods:
```julia
    BinomialOffspring(n, p) # Binomial distribution with n trials and success rate p
    BinomialOffspring(n)    # Binomial distribution with n trials and p = 0.5
    BinomialOffspring(p)    # Binomial distribution with 3 trails and success rate p
    BinomialOffspring()     # Binomial distribution with n = 3 and p = 0.5

    sample([rng,] ξ)        # Sample a random observation from the distribution
    mean(ξ)                 # Get the distribution mean
    variance(ξ)             # Get the distribution variance
```
"""
struct BinomialOffspring{T<:Real} <: GaltonWatsonDistribution
    n::Int
    p::T
    function BinomialOffspring{T}(n,p) where {T<:Real}
        n >= 0 || throw(DomainError(n, "argument must be a non-negative integer"))
        zero(p) <= p <= one(p) || throw(DomainError(p, "argument must be in the range [0,1]"))
        new(n, p)
    end
end

BinomialOffspring(n::Int, p::T) where {T<:Real} = BinomialOffspring{T}(n, p)
BinomialOffspring(p::T) where {T<:Real} = BinomialOffspring{T}(3, p)
BinomialOffspring(n::Int) = BinomialOffspring(n, 1//2)
BinomialOffspring() = BinomialOffspring(3, 1//2)

function sample(rng::AbstractRNG, ξ::BinomialOffspring)::Int
    rand(rng, Binomial(ξ.n, ξ.p))
end
mean(ξ::BinomialOffspring) = ξ.n * ξ.p
variance(ξ::BinomialOffspring) = ξ.n * ξ.p * (1 - ξ.p)