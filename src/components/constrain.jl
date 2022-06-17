using StaticArrays
using WidgetsBase: AbstractWidget, to_node
using Observables


# This widget is meant to receive as input a vector of fixed size, e.g., filters in conv layers.
struct StaticArrayInput{N, T} <: AbstractWidget{SVector{N,T}}
    value::Observable{SVector{N,T}}
    attributes::Dict{Symbol, Any}

    function StaticArrayInput{N}(value::Vector{T}; kw...) where {N} where T<:Number
        new{N, typeof(first(value))}(Observable(SVector{N, T}(value)), Dict{Symbol, Any}(kw))
    end
end

struct ConstrainedNumInput{T <: AbstractRange, ET} <: AbstractWidget{T}
    range::Observable{T}
    value::Observable{ET}
    attributes::Dict{Symbol, Any}
end

function ConstrainedNumInput(range::T, value = first(range); kw...) where T <: AbstractRange
    ConstrainedNumInput{T, eltype(range)}(
        to_node(range),
        to_node(value),
        Dict{Symbol, Any}(kw)
    )
end

in_range(range, value) = value in range || error("Value out of range")

constrain(num_input::ConstrainedNumInput) = onany(in_range, num_input.range, num_input.value)



