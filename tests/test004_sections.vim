let text = join(readfile("test004_sections.in"), "\n")

source helpers/complex_data.vim

let tokens = vmustache#Tokenize(text)
" echo "Tokens:"
" echo tokens
let template = vmustache#Parse(tokens)
" echo "Template:"
" echo template
" echo "Rendered:"
echo vmustache#Render(template, GetTestData())
call vimtest#Quit()
