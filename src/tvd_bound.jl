# Calculate an upper bound on the one-step total variation distance between a
# PDSBP and a CBP with matching first and second moments, started from the same
# point. See Lemma 4.3.1 for details
function one_step_tvd_bound(;z::Real, h::Real, R::Real, η::Real, σ²::Real)
    z ≤ 0 && throw(DomainError(z, "argument must be positive"))
    h ≤ 0 && throw(DomainError(h, "argument must be positive"))
    R ≤ 0 && throw(DomainError(R, "argument must be positive"))
    0 ≤ η ≤ 1//4 || throw(DomainError(η, "argument must be in the range [0, 1/4]"))
    σ² ≤ 0 && throw(DomainError(σ², "argument must be positive"))

    σ³ = σ²^(3/2)

    𝔍₁ = (√2(3R + 2(1+h)σ²)) / (σ²*min(h,1)√(π*η*z))
    𝔍₂ = ((5√(2π) + 3π/2)*(1+h)R + h*σ²) / (σ³√(2π*h^3*z))

    return 𝔍₁ + 𝔍₂
end


# Calculate an upper bound on the k-step total variation distance between a
# PSDBP and a CBP with matching first and second moments, started from th same
# point. See Corollary 4.3.3 for details
function k_step_tvd_bound(;k::Integer, z::Real, h::Real, R::Real, η::Real, σ²::Real, m::Real, α::Real)
    if k ≤ 0
        throw(DomainError(k, "argument must be a positive integer"))
    elseif k == 1
        return one_step_tvd_bound(z=z, h=h, R=R, η=η, σ²=σ²)
    end

    z ≤ 0 && throw(DomainError(z, "argument must be positive"))
    h ≤ 0 && throw(DomainError(h, "argument must be positive"))
    R ≤ 0 && throw(DomainError(R, "argument must be positive"))
    0 ≤ η ≤ 1//4 || throw(DomainError(η, "argument must be in the range [0, 1/4]"))
    σ² ≤ 0 && throw(DomainError(σ², "argument must be positive"))
    m ≤ 0 && throw(DomainError(m, "argument must be positive"))
    0 < α < 1 || throw(DomainError(α, "argument must be in the range (0, 1)"))

    σ³ = σ²^(3/2)

    b₁ = (√2(3R + 2(1+h)σ²)) / (σ²*min(h,1)√(π*η))
    b₂ = ((5√(2π) + 3π/2)*(1+h)R + h*σ²) / (σ³√(2π*h^3))
    b = b₁ + b₂

    αmh = α*m*h
    c₁ = (b√αmh)/(√αmh - 1)
    c₂ = (α*σ²)/((1-α)^2*(αmh - 1)m)

    return (c₁*(1 - αmh^(-k/2)))/√z + (c₂*(1 - αmh^(-k+1)))/z
end
