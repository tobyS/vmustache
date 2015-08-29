let text = join(readfile("test019_view_model_overriding.in"), "\n")
let data = {}
let data["overwritten"] = "From Data!"

let b:vmustache_view_model = {}
let b:vmustache_view_model["overwritten"] = "From View!"

echo vmustache#RenderString(text, data)
call vimtest#Quit()
