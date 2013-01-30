let s:old_cpo = &cpo
set cpo&vim

let text = join(readfile("test015_tripleBrace.in"), "\n")

let data = {"name": "sometext"}

let tokens = vmustache#Tokenize(text)
" echo "Tokenized:"
" echo tokens
let template = vmustache#Parse(tokens)
" echo "Parsed:"
" echo template
" echo "Rendered:"
echo vmustache#Render(template, data)
" echo "END"
call vimtest#Quit()

let &cpo = s:old_cpo
