function normsq(x::Vector)
    s = 0.0
    for i in 1:length(x)
        s += x[i]^2
    end
    return s
end
