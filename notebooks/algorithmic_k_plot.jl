module AlgorithmicKPlot

using Distributions
using Random
using Plots
using Plots.PlotMeasures

# Minimum probability of a NB(z+1, 0.5) distribution and a Poi(2*Bin(z+1, 0.5))
# distribution (the sum of z+1 ZIP(2, 0.5) distributions)
function min_psdbp_dcbp_prob(z::Integer, k::Integer)
    psdbp_prob = pdf(NegativeBinomial(z+1, 0.5), k)
    dcbp_prob = pdf(Binomial(z+1, 0.5), 0)
    for i = 1:z+1
        dcbp_prob += pdf(Binomial(z+1, 0.5), i) * pdf(Poisson(2*i), k)
    end

    min(psdbp_prob, dcbp_prob)
end

max_chain_length = 50
num_trials = 10000
fail_count = zeros(Int, max_chain_length)

rng = Xoshiro(97)

for i = 1:num_trials
    if i % 100 == 0
        println(i)
    end

    z = 100
    truncation_prob = 2z
    for n = 1:max_chain_length
        if z == 0  # Extinct chains always stick together
            break
        end

        is_failed = false
        u = rand(rng)
        c = 0
        for k = 0:truncation_prob+1
            if u < c  # Chains have stuck together
                z = k
                break
            elseif k == truncation_prob+1  # Reached our truncation point
                global fail_count[n] += 1
                is_failed = true
                break
            end

            c += min_psdbp_dcbp_prob(z, k)
        end

        if is_failed
            break
        end
    end
end

estimated_tvd = cumsum(fail_count)/num_trials

p = plot(
    1:length(estimated_tvd),
    estimated_tvd,
    title = "Estimated TVD upper bound over K, algorithmic approach",
    xlabel = "K",
    ylabel = "Estimated TVD Upper Bound",
    linecolor = :purple,
    linealpha = 0.8,
    linewidth = 2,
    legend = false,
    fontfamily = "Computer Modern",
    titlefontsize = 24,
    tickfontsize = 16,
    guidefontsize = 16,
    size = (1400, 1000),
    ylims = (0,1),
    bottom_margin = 12mm,
    left_margin = 12mm,
    top_margin = 3mm
)

display(p)

end