module MCMC2
	using Distributions, Vega

	export LogDensityFunction, NonDifferentiableDensity, DifferentiableDensity
	export ElementSampler, ParameterSampler
	export ParameterMetadata
	export MCMCModel
	export MCMCSamples
	export SliceSampler, MetropolisSampler, HMCSampler
	export mcmc
	export nparameters, nsamples, nchains
	export traceplot

	include("utils.jl")

	include("density.jl")
	include("sampler.jl")
	include("samples.jl")
	include("parameter_metadata.jl")
	include("model.jl")

	include("slice.jl")
	include("metropolis.jl")
	include("hmc.jl")

	include("mcmc.jl")

	include("postprocess.jl")
end
