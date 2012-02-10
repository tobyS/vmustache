let text = join(readfile("test002.in"), "\n")
call vmustache#DumpTemplate(vmustache#Parse(vmustache#Tokenize(text)))
call vimtest#Quit()
