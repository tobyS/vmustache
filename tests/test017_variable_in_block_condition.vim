let text = join(readfile("test017_variable_in_block_condition.in"), "\n")
let data = {}
let data["true"] = 1
let data["false"] = 0

let tokens = vmustache#Tokenize(text)
" echo tokens
echo vmustache#Render(vmustache#Parse(tokens), data)
call vimtest#Quit()
