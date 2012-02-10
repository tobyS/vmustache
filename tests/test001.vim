let text = join(readfile("test001.in"), "\n")
call vmustache#DumpTokens(vmustache#Tokenize(text))
call vimtest#Quit()
