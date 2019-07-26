using BenchmarkTools
using Plots
using Random
using TupleSort
pyplot()

#=
function permutations(things)
    if length(things) <= 1
        return [things]
    end
    perms = []
    for i in 1:length(things)
        for rest in permutations((things[1:i - 1]..., things[i + 1:end]...))
            push!(perms, (things[i], rest...))
        end
    end
    return perms
end
=#

N = 16
tuplesort_times = zeros(N)
referencesort_times = zeros(N)

@generated function referencesort(stuff::NTuple{N}) where {N}
    return quote
        s = sort!(Base.copymutable(stuff))
        return ($([:(s[$n]) for n = 1:N]...),)
    end
end

for n = 1:N
    println(n)
    tuplesort_times[n] += time(@benchmark sort(perm) setup = (perm = (randperm($n)...,)) samples = 10)
    referencesort_times[n] += time(@benchmark referencesort(perm) setup = (perm = (randperm($n)...,)) samples = 10)
end

plot(0:N, [0, tuplesort_times...], label="TupleSort")
plot!(0:N, [0, referencesort_times...], label="sort!")

savefig("plot.png")