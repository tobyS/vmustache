let text = join(readfile("test001_tokenize.in"), "\n")
call vmustache#DumpTokens(vmustache#Tokenize(text))
call vimtest#Quit()
