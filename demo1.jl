using Distributions, Vega, MCMC2

K = 2
μ = zeros(K)
μ[1] = 10.0
Σ = eye(K)
for i in 1:K
    for j in (i + 1):K
        Σ[i, j] = 0.9
        Σ[j, i] = 0.9
    end
end
d = MultivariateNormal(μ, Σ)
f(x) = logpdf(d, x)

density = NonDifferentiableDensity(f)
meta = ParameterMetadata(K)
samplers = [SliceSampler, SliceSampler]

model = MCMCModel(density, meta, samplers)

x0 = -10 * ones(K)

n_samples = 5_000
s = mcmc(model, n_samples, 4, x0)

plot(x = vec(s.samples[1, :]),
	 y = vec(s.samples[2, :]),
	 kind = :scatter)

plot(x = [1:length(s.ll[:, 1])],
	 y = s.ll[:, 1],
	 kind = :line)

traceplot(s, 1)

traceplot(s, 2)
