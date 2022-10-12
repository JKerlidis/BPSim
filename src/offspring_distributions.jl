### Define the abstract distribution types and sample function ###
abstract type OffspringDistribution end
abstract type GWOffspringDistribution <: OffspringDistribution end
abstract type PSDBPOffspringDistribution <: OffspringDistribution end

sample(rng::AbstractRNG, ξ::T, ::Integer) where {T<:OffspringDistribution} = sample(rng, ξ)
sample(rng::AbstractRNG, ξ::T) where {T<:GWOffspringDistribution} = throw(MethodError(rng, ξ))
sample(ξ::T) where {T<:GWOffspringDistribution} = sample(Xoshiro(), ξ::T)

sample(rng::AbstractRNG, ξ::T, z::Integer) where {T<:PSDBPOffspringDistribution} = throw(MethodError(rng, ξ, z))
sample(ξ::T, z::Integer) where {T<:PSDBPOffspringDistribution} = sample(Xoshiro(), ξ::T, z::Integer)

### Load the implementation of specific offspring distributions ###
include(joinpath("offspring_distributions", "galton_watson.jl"))
include(joinpath("offspring_distributions", "psdbp.jl"))
