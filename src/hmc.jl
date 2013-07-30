# Adapted directly from Radford Neal's R code
# TODO: This is a ParameterSampler
function hmc!(q1::Vector{Float64},
              q0::Vector{Float64},
              gr::Vector{Float64},
              p::Vector{Float64},
              d::DifferentiableDensity,
              ε::Real = 0.01,
              L::Integer = 20)
    k = length(q0)

    # Assumes q is already set to current position
    # p will be momentum, gr gradient
    copy!(q1, q0)

    # independent standard normal variates as a row vector
    randn!(p)

    # Evaluate potential and kinetic energies at start of trajectory
    U0 = d.f(q0)
    K0 = normsq(p) / 2

    # Make a half step for momentum at the beginning
    d.g!(gr, q1)
    for i in 1:k
        p[i] = p[i] - ε * gr[i] / 2
    end

    # Alternate full steps for position and momentum
    for i in 1:L
        # Make a full step for the position
        for i in 1:k
            q1[i] = q1[i] + ε * p[i]
        end
        # Make a full step for the momentum, except at end of trajectory
        if i != L
            d.g!(gr, q1)
            for i in 1:k
                p[i] = p[i] - ε * gr[i]
            end
        end
    end

    # Make a half step for momentum at the end.
    d.g!(gr, q1)
    for i in 1:k
        p[i] = p[i] - ε * gr[i] / 2
    end

    # Negate momentum at end of trajectory to make the proposal symmetric
    for i in 1:k
        p[i] = -p[i]
    end

    # Evaluate potential and kinetic energies at start and end of trajectory
    U1 = d.f(q1)
    K1 = normsq(p) / 2

    # Accept or reject the state at end of trajectory, returning either
    # the position at the end of the trajectory or the initial position
    if log(rand()) < U0 - U1 + K0 - K1
        # accept
        return U1
    else
        # reject
        copy!(q1, q0)
        return U0
    end
end

HMCSampler = ParameterSampler(hmc!)
