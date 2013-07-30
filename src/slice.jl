# Ported from Radford Neal's R code, with a few things missing
function slice!(θ1::Vector{Float64},
                θ0::Vector{Float64},
                i::Integer,
                d::LogDensityFunction,
                fθ0::Real = d.f(θ0),
                lower::Real = -Inf,
                upper::Real = +Inf,
                w::Real = 0.5,
                m::Int = 10_000)
    # Sanity checks
    if w <= 0
        error("w must be non-negative")
    end
    if m <= 0
        error("m must be non-negative")
    end
    if upper < lower
        error("Upper limit must be above lower limit")
    end

    # Copy θ0 into θ1
    copy!(θ1, θ0)

    # Determine the slice level in log terms
    logy::Float64 = fθ0 - rand(Exponential(1.0))

    # Find the initial interval to sample from
    u::Float64 = w * rand()
    L::Float64 = θ0[i] - u
    R::Float64 = θ0[i] + (w - u)

    # Expand the interval until its ends are outside the slice, or until
    # the limit on steps is reached
    J::Int = ifloor(m * rand())
    K::Int = (m - 1) - J

    # Determine lower boundary
    θ1[i] = L
    while J > 0
        if L <= lower || d.f(θ1)::Float64 <= logy
            break
        end
        L -= w
        θ1[i] = L
        J -= 1
    end

    # Determine upper boundary
    θ1[i] = R
    while K > 0
        if R >= upper || d.f(θ1)::Float64 <= logy
            break
        end
        R += w
        θ1[i] = R
        K -= 1
    end

    # Shrink interval to lower and upper bounds
    L = L < lower ? lower : L
    R = R > upper ? upper : R

    # Sample from the interval, shrinking it on each rejection
    fθ1::Float64 = NaN
    while true
        θ1[i] = rand() * (R - L) + L
        fθ1 = d.f(θ1)::Float64
        if fθ1 >= logy
            break
        end
        if θ1[i] > θ0[i]
            R = θ1[i]
        else
            L = θ1[i]
        end
    end

    return fθ1
end

# This wrapping may be superfluous/wasteful
SliceSampler = ElementSampler(slice!)
