using Documenter, DashiBoard

let dir = joinpath(@__DIR__, "src", "tabs")
    for fn in readdir(joinpath(dir, "src"))
        open(joinpath(dir, fn), "w") do io
            for line in eachline(joinpath(dir, "src", fn), keep=true)
                m = match(r"{{([a-z]*)}}", line)
                if isnothing(m)
                    write(io, line)
                else
                    component = m[1]
                    path = joinpath(dir, "components", m[1] * ".md")
                    write(io, read(path))
                end
            end
        end
    end
end

makedocs(;
    modules=[DashiBoard],
    authors="Pietro Vertechi <pietro.vertechi@protonmail.com>",
    repo="https://github.com/piever/DashiBoard.jl/blob/{commit}{path}#{line}",
    sitename="Data Visualization",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
    ),
    pages=Any[
        "Home" => "index.md",
        "Getting Started" => "getting_started.md",
        "Tabs" => [
            "Load" => "tabs/load.md",
            "Filter" => "tabs/filter.md",
            "Predict" => "tabs/predict.md",
            "Cluster" => "tabs/cluster.md",
            "Project" => "tabs/project.md",
            "Visualize" => "tabs/visualize.md",
        ],
        "How to Guides" => [
            "Filter" => "how_to_guides/filter.md",
            "Visualize" => "how_to_guides/visualize.md",
        ],
        "API" => "API.md",
    ],
    strict=false, # FIMXE: change to true once all docstrings are included
)

deploydocs(;
    repo="github.com/piever/DashiBoard.jl",
    push_preview=true,
    devbranch="main",
)