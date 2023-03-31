struct Togglers
    options::Vector{Option}
end

# FIXME: allow observable list as input, to avoid rebuilding...

function jsrender(session::Session, togglers::Togglers)
    options = togglers.options
    toggles = map(options) do entry
        selected = entry.selected
        isoriginal = entry.value.isoriginal
        reset = Observable(true)
        # register_resource!(session, reset)
        on(session, reset) do _
            reset!(entry.value)
        end
        modified = DOM.span(
            class="float-right p-4 inline-block hover:text-red-300",
            "⬤",
            style=isoriginal[] ? "display:none" : "display:inline",
            onclick=js"event => $(reset).notify(true)"
        )
        onjs(session, isoriginal, js"""
            function (val) {
                $(modified).style.display = val ? "none" : "inline";
            }
        """
        )
        content = DOM.div(style="display:none", class="p-4 bg-white rounded-b", jsrender(session, entry.value))
        button = DOM.button(
            class="text-blue-800 text-xl font-semibold border-b-2 border-gray-200 hover:bg-gray-200 w-full text-left",
            onclick=js"""event => {
                if (!$(modified).isEqualNode(event.target)) {
                    $selected.notify(!($selected).value)
                }
            }
            """, # FIXME: may need to be a string
            DOM.span(class="pl-4 py-4 inline-block", entry.key),
            modified
        )
        onjs(
            session,
            selected,
            js"""
                function (val) {
                    $(content).style.display = val ? "block" : "none";
                    $(button).classList.toggle("border-b-2")
                }
            """
        )
        return DOM.div(button, content)
    end
    return DOM.div(toggles...)
end
