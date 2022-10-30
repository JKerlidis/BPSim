module AlgorithmicZPlot

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


z_range = 1:30
num_trials = 10000
fail_count = zeros(Int, length(z_range))

rng = Xoshiro(97)

for j = z_range
    z = 10j
    truncation_prob = 20j
    for i = 1:num_trials
        if i % 1000 == 0
            println("z: "*string(z)*", i: "*string(i))
        end

        u = rand(rng)
        c = 0
        for k = 0:truncation_prob+1
            if u < c  # Chains have stuck together
                break
            elseif k == truncation_prob+1  # Reached our truncation point
                global fail_count[j] += 1
                break
            end

            c += min_psdbp_dcbp_prob(z, k)
        end
    end
end

estimated_tvd = fail_count/num_trials

println(estimated_tvd)

p = plot(
    1:length(estimated_tvd),
    estimated_tvd,
    title = "Estimated TVD upper bound over z, algorithmic approach",
    xlabel = "z",
    ylabel = "Estimated TVD Upper Bound",
    linecolor = :purple,
    linealpha = 0.8,
    linewidth = 2,
    legend = false,
    fontfamily = "Computer Modern",
    titlefontsize = 24,
    tickfontsize = 16,
    guidefontsize = 16,
    xformatter = j -> trunc(Int, 10j),
    ylims = (0, 0.06),
    size = (1400, 1000),
    bottom_margin = 12mm,
    left_margin = 12mm,
    top_margin = 3mm
)

display(p)

end