# Density functions can be left unnormalized
abstract LogDensityFunction

immutable NonDifferentiableDensity <: LogDensityFunction
    f::Function
end

immutable DifferentiableDensity <: LogDensityFunction
    f::Function
    g!::Function
end
