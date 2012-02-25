let text = join(readfile("test003_render.in"), "\n")
let data = {}
let data["variable"] = "Some fancy info"
let data["outer_section"] = []

let innersect = []
call add(innersect, {"foo": 1, "bar": 2, "baz": 3})
call add(innersect, {"foo": 4, "bar": 5, "baz": 6})

call add(data["outer_section"], {"some_variable": "Hooray!", "inner_section": innersect})
call add(data["outer_section"], {"some_variable": "Haya!", "inner_section": innersect})

let tokens = vmustache#Tokenize(text)
" echo tokens
echo vmustache#Render(vmustache#Parse(tokens), data)
call vimtest#Quit()
