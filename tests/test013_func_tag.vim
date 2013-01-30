let text = join(readfile("test013_func_tag.in"), "\n")

let tokens = vmustache#Tokenize(text)
" echo "Tokenized:"
" echo tokens
let template = vmustache#Parse(tokens)
" echo "Parsed:"
" echo template
" echo "Rendered:"
echo vmustache#Render(template, {})
" echo "END"
call vimtest#Quit()
