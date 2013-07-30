immutable ParameterMetadata
    lower::Vector{Float64}
    upper::Vector{Float64}
    discrete::BitVector

    function ParameterMetadata(l::Vector{Float64},
                               u::Vector{Float64},
                               d::BitVector)
    	k = length(l)
    	if length(u) != k
    		error("u must have the same length as l")
    	end
    	if length(d) != k
    		error("d must have the same length as l")
    	end
    	return new(l, u, d)
    end
end

function ParameterMetadata(k::Integer)
    ParameterMetadata(-infs(k),
    	              infs(k),
    	              falses(k))
end
