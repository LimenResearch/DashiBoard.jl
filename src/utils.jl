"""
This is borrowed from DataFrames.jl. Suggest up to 8 names in which differ little
from what the user typed in Levenshtein distance.
"""
function fuzzymatch(colnames, name::Symbol)
    ucname = uppercase(string(name))
    dist = [(levenshtein(uppercase(string(x)), ucname), x) for x in colnames]
    sort!(dist)
    c = [count(x -> x[1] <= i, dist) for i in 0:2]
    maxd = max(0, searchsortedlast(c, 8) - 1)
    return [s for (d, s) in dist if d <= maxd]
end

colnames(table) = string.(Tables.columnnames(table))

vecmap(f, iter) = [f(el) for el in iter]

function data_options(t::Observable; keywords=[""], suffix="")
    return lift(t) do table
        names = map(name -> name * suffix, colnames(table))
        return [keyword => names for keyword in keywords]
    end
end

iscontinuous(v::AbstractVector) = false
iscontinuous(v::AbstractVector{<:Number}) = true
iscontinuous(v::AbstractVector{<:Bool}) = false

function indexoftype(::Type{T}, list, el) where {T}
    idx = 0
    for x in list
        idx += x isa T
        isequal(x, el) && return idx
    end
    return nothing
end

macro maybereturn(x)
    expr = quote
        local tmp = $(esc(x))
        isnothing(tmp) && return nothing
        tmp
    end
    return expr
end

function buttonclass(positive)
    class = "text-xl font-semibold rounded text-left py-2 px-4 bg-opacity-75"
    class *= positive ? " bg-blue-100 hover:bg-blue-200 text-blue-800 hover:text-blue-900 mr-8" :
        " bg-red-100 hover:bg-red-200 text-red-800 hover:text-red-900"
    return class
end

struct Call
    fs::Vector{String}
    positional::Vector{String}
    named::Vector{Pair{String, String}}
end

Call() = Call(String[], String[], Pair{String, String}[])

function compute_calls(str::AbstractString)
    calls, call = Call[], Call()
    for chunk in split(str, ' ')
        isempty(chunk) && continue
        s = split(chunk, ':')
        if length(s) == 1
            if only(s) == "+"
                push!(calls, call)
                call = Call()
            else
                push!(call.fs, only(s))
            end
        else
            pre, post = s
            positional, named = call.positional, call.named
            isempty(pre) ? push!(positional, post) : push!(named, pre => post)
        end
    end
    push!(calls, call)
    return calls
end

for sym in (:on, :onany)
    trysim = Symbol(:try, sym)
    @eval function $trysim(f, session::Session, obs::Observable...)
        error_msg = Observable("")
        onjs(session, error_msg, js"""
            function (value) {
                alert(value);
            }
        """)
        return $sym(session, obs...) do args...
            try
                f(args...)
            catch err
                io = IOBuffer()
                print(io, "Could not complete command due to the following error.")
                print(io, "\n\n")
                print(io, err)
                error_msg[] = String(take!(io))
            end
        end
    end
end

function move_item(v, (old, new))
    return map(1:length(v)) do i
        i == new && return v[old]
        old ≤ i ≤ new && return v[i+1]
        old ≥ i ≥ new && return v[i-1]
        return v[i]
    end
end

function remove_item(v, idx)
    return map(1:length(v)-1) do i
        return i < idx ? v[i] : v[i+1]
    end
end

function insert_item(v, idx, value)
    return map(1:length(v)+1) do i
        i < idx && return v[i]
        i > idx && return v[i-1]
        return value
    end
end

function scrollable_component(args...; kwargs...)
    return DOM.div(
        DOM.div(args...; class="absolute left-0 right-8");
        class="overflow-y-scroll h-full w-full relative",
        kwargs...
    )
end
