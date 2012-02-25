let text = join(readfile("test009_tokenize_negative_section.in"), "\n")

let tokens = vmustache#Tokenize(text)
echo tokens
call vimtest#Quit()
