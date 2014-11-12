let text = join(readfile("test016_block_variable_empty.in"), "\n")
let data = {}
let data["block_not_empty_string"] = "foo"
let data["block_empty_string"] = ""

let tokens = vmustache#Tokenize(text)
" echo tokens
echo vmustache#Render(vmustache#Parse(tokens), data)
call vimtest#Quit()
