let s:old_cpo = &cpo
set cpo&vim

let text = join(readfile("test012_bug_render_list_empty.in"), "\n")

let data = {
	\ "name": "some name",
	\ "parameters": []
\ }

let tokens = vmustache#Tokenize(text)
" echo tokens
let template = vmustache#Parse(tokens)
" echo template
echo vmustache#Render(template, data)
echo "END"
call vimtest#Quit()

let &cpo = s:old_cpo
