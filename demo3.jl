using Distributions
using MCMC2
using Calculus
using Vega

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
function g!(gr, x)
	Calculus.finite_difference!(f, x, gr, :central)
	return
end

# Initial conditions
x0 = [0.0, 0.0]
x1 = copy(x0)
gr = copy(x0)
g!(gr, x0)
p = copy(x0)
dens = DifferentiableDensity(f, g!)

# Tuning parameters
epsilon = 0.001  # step size
L = 10           # number of steps

# Basic tests on regular interface
samples = Array(Float64, k, 5_000)
for i in 1:5_000
	fx1 = MCMC2.hmc!(x1, x0, gr, p, dens, epsilon, L)
	samples[:, i] = x1
end

plot(x = vec(samples[1, :]),
	 y = vec(samples[2, :]),
	 kind = :scatter)
