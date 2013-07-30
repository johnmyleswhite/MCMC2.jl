# How to control sampler-specific parameter settings?
# How to provide nice initialization rules?
# How to control number of chains?
function mcmc(m::MCMCModel, n_samples::Integer, θinit::Vector{Float64})
    # Size of parameter vector
    k = length(θinit)

    # Buffer for current and next point
    θ0 = copy(θinit)
    θ1 = Array(Float64, k)

    samples = Array(Float64, k, n_samples)
    ll = Array(Float64, n_samples)

    fθ0 = m.density.f(θ0)
    fθ1 = fθ0

    for s in 1:n_samples
        # Iterate over parameters one-by-one
        for i in 1:k
            fθ1 = m.samplers[i].sampler!(θ1,
                                         θ0,
                                         i,
                                         m.density,
                                         fθ0,
                                         m.meta.lower[i],
                                         m.meta.upper[i])
            copy!(θ0, θ1)
            fθ0 = fθ1
        end

        # Store updated parameter setting
        samples[:, s] = θ1

        # Store log likelihood
        ll[s] = fθ1
    end

    return MCMCSamples(samples, ll)
end

function mcmc(m::MCMCModel,
              n_samples::Integer,
              n_chains::Integer,
              θinit::Vector{Float64})
    # Size of parameter vector
    k = length(θinit)

    # Buffer for current and next point
    θ0 = copy(θinit)
    θ1 = Array(Float64, k)

    samples = Array(Float64, k, n_samples, n_chains)
    ll = Array(Float64, n_samples, n_chains)

    # t = pmap(i -> mcmc(model, n_samples, θinit), 1:n_chains)
    # for i in 1:n_chains
    #     samples[:, :, i] = t[i].samples
    #     ll[:, i] = t[i].ll
    # end

    for i in 1:n_chains
        s = mcmc(m, n_samples, θinit)
        samples[:, :, i] = s.samples
        ll[:, i] = s.ll
    end

    return MCMCSamples(samples, ll)
end
