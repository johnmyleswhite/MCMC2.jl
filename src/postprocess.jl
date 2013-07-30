nparameters(s::MCMCSamples) = size(s.samples, 1)
nsamples(s::MCMCSamples) = size(s.samples, 2)
nchains(s::MCMCSamples) = size(s.samples, 3)

function Base.mean(s::MCMCSamples)
	@printf "        "
	for c in 1:nchains(s)
		@printf "Chain %-7d " c
	end
	@printf "\n"
	@printf "        "
	for c in 1:nchains(s)
		@printf "------------- "
	end
	@printf "\n"
	for p in 1:nparameters(s)
		@printf " P%-4d: " p
		for c in 1:nchains(s)
			@printf "%13f " mean(s.samples[p, :, c])
		end
		@printf "\n"
	end
	return
end

# mean(s)

function Base.median(s::MCMCSamples)
	@printf "        "
	for c in 1:nchains(s)
		@printf "Chain %-7d " c
	end
	@printf "\n"
	@printf "        "
	for c in 1:nchains(s)
		@printf "------------- "
	end
	@printf "\n"
	for p in 1:nparameters(s)
		@printf " P%-4d: " p
		for c in 1:nchains(s)
			@printf "%13f " median(s.samples[p, :, c])
		end
		@printf "\n"
	end
	return
end

# median(s)

function Base.var(s::MCMCSamples)
	@printf "        "
	for c in 1:nchains(s)
		@printf "Chain %-7d " c
	end
	@printf "\n"
	@printf "        "
	for c in 1:nchains(s)
		@printf "------------- "
	end
	@printf "\n"
	for p in 1:nparameters(s)
		@printf " P%-4d: " p
		for c in 1:nchains(s)
			@printf "%13f " var(s.samples[p, :, c])
		end
		@printf "\n"
	end
	return
end

# var(s)

function traceplot(s::MCMCSamples, p::Integer)
	count = nsamples(s) * nchains(s)
	g = Array(Int, count)
	for i in 1:count
		g[i] = fld(i - 1, nsamples(s)) + 1
	end
    plot(x = [mod(i, nsamples(s)) for i in 1:count],
    	 y = vec(s.samples[p, :, :]),
    	 group = g,
	     kind = :line)
end
