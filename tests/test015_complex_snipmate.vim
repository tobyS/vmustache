let s:old_cpo = &cpo
set cpo&vim

let text = join(readfile("test015_complex_snipmate.in"), "\n")

let data = {
	\ "name": "someFunction",
	\ "parameters": [
	    \ {"type": "array", "name": "first"},
	    \ {"name": "second"},
	\ ]
\ }

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
