using TOML
using Graphs
using Combinatorics
using GLMakie, GraphMakie

Base.@kwdef mutable struct MetaGraph
    key_value::Vector{Pair{String, Any}} = []
    kv_graph::Graphs.SimpleGraph{Int} = Graphs.SimpleGraph()
end

function cooccurrence(vector::Any, ref_vec::Any, graph::Graphs.SimpleGraph{Int})
    for pair in Combinatorics.combinations(vector, 2)
        if .!(pair[1] in ref_vec)
            push!(ref_vec, pair[1])
            add_vertex!(graph)
        end
        if .!(pair[2] in ref_vec)
            push!(ref_vec, pair[2])
            add_vertex!(graph)
        end
        i = findfirst(x -> x == pair[1], ref_vec)[1]
        j = findfirst(x -> x == pair[2], ref_vec)[1]
        add_edge!(graph, i, j)
    end
    return graph
end

function cooccurrence(dict, metagraph::MetaGraph)
    metagraph.kv_graph = cooccurrence(collect(dict), metagraph.key_value,
                                      metagraph.kv_graph)
    return metagraph
end

star(g::SimpleGraph, v::Int) = Graphs.adjacency_matrix(g)[v, :].nzind
function star(m::MetaGraph; k::String=nothing, v::Any=nothing)
    @assert any(.!isnothing.([k, v]))
    if all(.!isnothing.([k, v]))
        ind = findfirst(x -> x == (k => v), m.key_value)
        star_inds = star(m.kv_graph, ind)
    else
        isnothing(k) ? (j, el) = (2, v) : (j, el) = (1, k)
        ind = findfirst(x -> x[j] == el, m.key_value)
        star_inds = star(m.kv_graph, ind)
    end
    return unique([m.key_value[star_ind][1] for  star_ind in star_inds
                   if m.key_value[star_ind][1] != k])
end

function read_toml_templates(template_folder::AbstractString)
    templates = [TOML.parsefile(joinpath(template_folder, template_path))
                 for template_path in readdir(template_folder)
                 if occursin(".toml", template_path)]
end


# folder = "./static/neuralnet_templates"
# templates = read_toml_templates(folder)

m = MetaGraph()
main = [
        Dict("f" => "conv", "out"=>10, "filter"=>[5,5], "sigma"=>"relu"),
        Dict("f" => "conv", "out"=>3, "filter"=>[5,5], "sigma"=>"relu"),
        Dict("f" => "dense", "out"=>10, "sigma"=>"relu"),
        Dict("f" => "dense", "out"=>100, "sigma"=>"identity"),
        Dict("f" => "dense", "out"=>10, "sigma"=>"relu"),
        Dict("f" => "rnn", "out"=>10, "sigma"=>"tanh"),
        Dict("f" => "lstm", "out"=>3),
        Dict("f" => "gru", "out"=>10)
    ]

for d in main
    m = cooccurrence(d, m)
end
star(m; k="f", v="dense")
