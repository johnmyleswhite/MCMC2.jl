immutable MCMCSamples
	# Each third-dimension is a chain
	# Each column is a sample
	# Each row is a parameter
	samples::Array{Float64}

	# Log likelihood per sample
	ll::Array{Float64}
end

function Base.show(io::IO, s::MCMCSamples)
	@printf io "MCMC samples\n"
	@printf io " * %d parameter(s)\n" size(s.samples, 1)
	@printf io " * %d sample(s)\n" size(s.samples, 2)
	@printf io " * %d chain(s)\n" size(s.samples, 3)
end
