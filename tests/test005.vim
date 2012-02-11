source helpers/complex_data.vim

echo vmustache#RenderFile("test005.in", GetTestData())
call vimtest#Quit()
