let text = join(readfile("test018_buffer_local_view_model.in"), "\n")
let data = {}
let data["from_data"] = "From Data!"

let b:vmustache_view_model = {}
let b:vmustache_view_model["from_view"] = "From View!"

echo vmustache#RenderString(text, data)
call vimtest#Quit()
