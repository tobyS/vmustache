let text = join(readfile("test011_render_negative_section.in"), "\n")

let data_rendered = {}
let data_not_rendered = {"negative_section": [{"variable": 1}, {"variable": 2}]}

let tokens = vmustache#Tokenize(text)
" echo tokens
let template = vmustache#Parse(tokens)
" echo template
echo "Inverted section rendered:"
echo vmustache#Render(template, data_rendered)
echo "Inverted section not rendered:"
let result = vmustache#Render(template, data_not_rendered)
echo result
echo "END"
call vimtest#Quit()
