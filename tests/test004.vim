let text = join(readfile("test004.in"), "\n")
let data = {}
let data["simple_variable"] = "a simple variable"
let data["single_section"] = "single section"
let data["multi_section"] = [1, 2, 3]
let data["variable_section"] = [{"variable": 23}, {"variable": 42}]
let data["nested_section"] = []

let innersect = []
call add(innersect, {"variable": "lala"})
call add(innersect, {"variable": "foobar"})

call add(data["nested_section"], {"variable": "Outer variable", "inner_section": innersect})
call add(data["nested_section"], {"variable": "Outer variable 2", "inner_section": innersect})

let tokens = vmustache#Tokenize(text)
" echo "Tokens:"
" echo tokens
let template = vmustache#Parse(tokens)
" echo "Template:"
" echo template
" echo "Rendered:"
echo vmustache#Render(template, data)
call vimtest#Quit()
