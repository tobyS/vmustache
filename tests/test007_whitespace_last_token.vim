let text = join(readfile("test007_whitespace_last_token.in"), "\n")
let data = {}
let data["name"] = "varName"
let data["type"] = "int"

let tokens = vmustache#Tokenize(text)
" echo tokens
echo vmustache#Render(vmustache#Parse(tokens), data)
call vimtest#Quit()
