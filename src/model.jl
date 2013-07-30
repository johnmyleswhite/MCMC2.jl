abstract ProbabilisticModel
# Must contain d and meta

# TODO: Provide a mechanism for providing ParameterSampler
immutable MCMCModel <: ProbabilisticModel
	density::LogDensityFunction
	meta::ParameterMetadata
	samplers::Vector{ElementSampler}
end
