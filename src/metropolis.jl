function metropolis!(θ1::Vector{Float64},
                     θ0::Vector{Float64},
                     i::Integer,
                     d::LogDensityFunction,
                     fθ0::Real = d.f(θ0),
                     lower::Real = -Inf,
                     upper::Real = +Inf,
                     sd::Real = 0.5)
    # Sanity checks
    if upper < lower
        error("Upper limit must be above lower limit")
    end

    # Copy θ0 into θ1
    copy!(θ1, θ0)

	θ1[i] += sd * randn()
 	fθ1 = d.f(θ1)
	if fθ1 - fθ0 > log(rand())
 		return fθ1
    else
    	θ1[i] = θ0[i]
    	return fθ0
  	end

    return fθ1
end

# This wrapping may be superfluous/wasteful
MetropolisSampler = ElementSampler(metropolis!)
