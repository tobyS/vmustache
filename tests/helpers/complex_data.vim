func! GetTestData()

	let l:data = {}
	let l:data["simple_variable"] = "a simple variable"
	let l:data["single_section"] = "single section"
	let l:data["multi_section"] = [1, 2, 3]
	let l:data["variable_section"] = [{"variable": 23}, {"variable": 42}]
	let l:data["nested_section"] = []

	let l:innersect = []
	call add(l:innersect, {"variable": "lala"})
	call add(l:innersect, {"variable": "foobar"})

	call add(l:data["nested_section"], {"variable": "Outer variable", "inner_section": innersect})
	call add(l:data["nested_section"], {"variable": "Outer variable 2", "inner_section": innersect})

	return l:data
endfunc
