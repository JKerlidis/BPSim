"""
    ControlFunction(f, is_random)

A wrapper over a function, ensuring that it has the required methods to act as
a control function.

Methods:
```julia
    ControlFunction(f)      # ControlFunction with function f provided
    ControlFunction()       # ControlFunction containing the identity function
    sample([rng,] φ, z)     # Sample from the control function, given a population size
```
"""
struct ControlFunction
    f::Function
    is_random::Bool
    function ControlFunction(f::Function)
        if length(methods(f, (AbstractRNG, Integer,))) > 0
            return new(f, true)
        elseif length(methods(f, (Integer,))) > 0
            return new(f, false)
        end
        throw(DomainError(f, "no valid method signature available"))
    end
end

ControlFunction() = ControlFunction(identity)


function sample(rng::AbstractRNG, φ::ControlFunction, z::Integer)::Int
    if !φ.is_random
        return φ.f(z)
    end
    φ.f(rng, z)
end

function sample(φ::ControlFunction, z::Integer)::Int
    if φ.is_random
        return sample(Xoshiro(), φ, z)
    end
    φ.f(z)
end 
