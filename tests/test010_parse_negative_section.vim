let text = join(readfile("test010_parse_negative_section.in"), "\n")

let tokens = vmustache#Tokenize(text)
" echo tokens
let template = vmustache#Parse(tokens)
echo template
call vimtest#Quit()
