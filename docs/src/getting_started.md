# Getting Started

This package can be installed typing
```julia
julia> import Pkg; Pkg.add(url="https://github.com/JuliaPlots/AlgebraOfGraphics.jl")
```
in the julia REPL.

The interface can be created using the [`UI`](@ref) constructor.
Use [`DashiBoard.app`](@ref) to generate and launch the user interface as
a local app.
Use [`DashiBoard.serve`](@ref) to generate and serve the user interface
at a given url and port.

## Copy-pastable code

Launching the app for local use:

```julia
using DashiBoard
set_aog_theme!() # set default theme
update_theme!(font=28) # update settings 
df = (x=rand(100), y=rand(100), z=rand(100))
app = DashiBoard.app(df, (:Filter, :Predict, :Visualize))
```

Starting a server with the app:

```julia
using DashiBoard
set_aog_theme!() # set default theme
update_theme!(font=28) # update settings 
df = (x=rand(100), y=rand(100), z=rand(100))
server = DashiBoard.serve(
    df,
    (:Filter, :Predict, :Visualize),
    url="0.0.0.0",
    port=9000
)
```

