source helpers/complex_data.vim

let text = join(readfile("test004.in"), "\n")

echo vmustache#RenderString(text, GetTestData())
call vimtest#Quit()
