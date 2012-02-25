source helpers/complex_data.vim

let text = join(readfile("test004_sections.in"), "\n")

echo vmustache#RenderString(text, GetTestData())
call vimtest#Quit()
