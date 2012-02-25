let text = join(readfile("test002_parse.in"), "\n")
call vmustache#DumpTemplate(vmustache#Parse(vmustache#Tokenize(text)))
call vimtest#Quit()
