let text = join(readfile("test008_block_variable_false.in"), "\n")
let data = {}
let data["block_rendered"] = 1
let data["block_not_rendered_false"] = 0

let tokens = vmustache#Tokenize(text)
" echo tokens
echo vmustache#Render(vmustache#Parse(tokens), data)
call vimtest#Quit()
