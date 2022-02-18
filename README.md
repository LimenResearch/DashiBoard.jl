# DashiBoard

[![CI](https://github.com/piever/DashiBoard.jl/workflows/CI/badge.svg?branch=main)](https://github.com/piever/DashiBoard.jl/actions?query=workflow%3ACI+branch%3Amain)
[![codecov.io](http://codecov.io/github/piever/DashiBoard.jl/coverage.svg?branch=main)](http://codecov.io/github/piever/DashiBoard.jl?branch=main)
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://piever.github.io/DashiBoard.jl/stable)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://piever.github.io/DashiBoard.jl/dev)

Navigate at the root of this repository and start Julia with `julia --project=app`.
Instantiate the project, then include `app/main.jl` to start the interface on `127.0.0.1:9000/`.

:warning: The settings in the `app/main.jl` file demo include a wild card, which is insecure on a server, as it can run arbitrary code.
If you are serving the app publicly, do not include `:Wildcard` among the options.

## Compilation

DashiBoard.jl can be compiled to a stand-alone app as follows:

```julia
using PackageCompiler
create_app("path/to/DashiBoard", "path/to/new/app/folder",
    include_transitive_dependencies=false)
```

For instance, provided PackageCompiler is installed in the global environment, one can navigate to the root folder of this repository and run

```
julia -q --project

julia> using Pkg, PackageCompiler

julia> create_app(".", "AppFolder", include_transitive_dependencies=false)
```
