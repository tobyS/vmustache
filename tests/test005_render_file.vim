source helpers/complex_data.vim

echo vmustache#RenderFile("test005_render_file.in", GetTestData())
call vimtest#Quit()
