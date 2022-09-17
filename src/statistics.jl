"""
    mean(sequence)

Calculates the mean of a given numeric sequence.
"""
function mean(sequence::Vector{<:Real})
    return sum(sequence) / length(sequence)
end

"""
    variance(sequence, corrected=true)

Calculates the variance of a given numeric sequence. If 'corrected' is true,
Bessel's correction is applied.
"""
function variance(sequence::Vector{<:Real}, corrected::Bool=true)
    return sum((sequence .- mean(sequence)).^2) / (length(sequence) - corrected)
end

"""
    std(sequence, corrected=true)

Calculates the standard deviation of a given numeric sequence. If 'corrected'
is true, Bessel's correction is applied.
"""
function std(sequence::Vector{<:Real}, corrected::Bool=true)
    return sqrt(variance(sequence, corrected))
end