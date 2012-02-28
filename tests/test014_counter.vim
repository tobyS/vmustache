let s:old_cpo = &cpo
set cpo&vim

let text = join(readfile("test014_counter.in"), "\n")

let data = {
	\ "parameters": [
	    \ {"name": "first"},
		\ {"name": "second"},
		\ {"name": "third"},
		\ {"name": "fourth"}
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
