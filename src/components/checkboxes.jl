struct Option{T}
    key::String
    value::T
    selected::Observable{Bool}
end

struct Checkboxes
    options::Vector{Any}
    value::Observable{Vector{Any}}
    dom::Hyperscript.Node{Hyperscript.HTMLSVG}
end

function Checkboxes(options;selected=fill(false, length(options)), option_to_string=string)

    selected = [convert(Observable{Bool}, sel) for sel in selected]
    options = convert(Vector{Any}, options)
    list = map(selected, options) do sel, option
        checkbox = JSServe.Checkbox(sel, Dict(:class => "form-checkbox"))
        label = DOM.span(class="ml-2", option_to_string(option))
        return DOM.label(checkbox, label)
    end
    dom = DOM.div(class="grid grid-cols-1 md:grid-cols-2 gap-4", TailwindCSS, list)
    
    value = Observable{Vector{Any}}(options[map(getindex, selected)])
    
    onany(selected...) do selected...
        value[] = options[collect(selected)]
    end
    return Checkboxes(options, value, dom)
end

jsrender(session::Session, wdg::Checkboxes) = jsrender(session, wdg.dom)
