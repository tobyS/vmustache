let tagmap = {}
let tagmap["{{#"] = "section_start"
let tagmap["{{/"] = "section_end"
let tagmap["{{&"] = "var_unescaped"
let tagmap["{{!"] = "comment"
let tagmap["{{[^#/&!]"]  = "var_escaped"

" TODO: Not supported are inverted sections and partials

"""""""""""""
" Tokenizing
"""""""""""""
func! vmustache#Tokenize(text)

	let l:regex = "{{[^}]*}}"

	let l:tokens = []
	let l:lastindex = -1
	let l:hasmore = 1

	while (l:hasmore > 0)
		let l:matchstart = match(a:text, l:regex, l:lastindex)
		if (l:matchstart != -1)
			let l:match = matchstr(a:text, l:regex, l:lastindex)
			let l:matchend = l:matchstart + strlen(l:match)
			if (l:lastindex != l:matchstart)
				call add(l:tokens, vmustache#ExtractTextToken(a:text, l:lastindex, l:matchstart))
			endif
			call add(l:tokens, vmustache#ExtractTagToken(a:text, l:matchstart, l:matchend))
			let l:lastindex = l:matchend
		else
			if (l:lastindex < strlen(a:text))
				call add(l:tokens, vmustache#ExtractTextToken(a:text, l:lastindex + 1, strlen(a:text)))
			endif
			let l:hasmore = 0
		endif
	endwhile

	return l:tokens
endfunc

func! vmustache#DumpTokens(tokens)
	for token in a:tokens
		echo "Token: " . token["type"]
		echo '"' . token["value"] . '"' . "\n"
	endfor
endfunc

func! vmustache#ExtractToken(text, start, end)
	return strpart(a:text, a:start, a:end - a:start)
endfunc

func! vmustache#ExtractTextToken(text, start, end)
	return {"type": "text", "value": vmustache#ExtractToken(a:text, a:start, a:end)}
endfunc

func! vmustache#ExtractTagToken(text, start, end)
	let l:token = vmustache#ExtractToken(a:text, a:start, a:end)
	return {"type": GetTagType(l:token), "value": vmustache#GetTagName(l:token) }
endfunc

func! GetTagType(tag)
	for l:key in keys(g:tagmap)
		if a:tag =~ l:key
			return g:tagmap[l:key]
		endif
	endfor
	throw "Could not recognize tag: " . a:tag
endfunc

func! vmustache#GetTagName(token)
	let l:matches = matchlist(a:token, '{{[#/&!]\?\([^}]\+\)}}')
    return l:matches[1]
endfunc

""""""""
" Parse
""""""""

func! vmustache#Parse(tokens)
	let l:stack = []
	for token in a:tokens
		call add(l:stack, token)
		if (token["type"] == "section_end")
			let l:stack = vmustache#ReduceSection(l:stack)
		elseif (token["type"] == "comment")
			let l:stack = vmustache#ReduceComment(l:stack)
		elseif (token["type"] == "var_escaped")
			let l:stack = vmustache#ReduceVariable(l:stack)
		endif
	endfor
	let l:stack = vmustache#ReduceTemplate(l:stack)
	return l:stack[0]
endfunc

func! vmustache#ReduceSection(stack)
	let l:endtoken = remove(a:stack, -1)
	let l:section = {"type": "section", "name": l:endtoken["value"], "children": []}
	let l:found = 0
	while (!empty(a:stack))
		let l:token = remove(a:stack, -1)
		if (l:token["type"] == "section_start" && l:token["value"] == l:endtoken["value"])
			let l:found = 1
			break
		endif
		call insert(l:section["children"], l:token)
	endwhile
	if (!l:found)
		throw "Section missmatch. Missing start tag for '" . l:section["name"] . "'"
	endif
	call add(a:stack, l:section)
	return a:stack
endfunc

func! vmustache#ReduceVariable(stack)
	let l:token = remove(a:stack, -1)
	let l:variable = {"type": "var_escaped", "name": l:token["value"]}
	call add(a:stack, l:variable)
	return a:stack
endfunc

func! vmustache#ReduceComment(stack)
	call remove(a:stack, -1)
	return a:stack
endfunc

func! vmustache#ReduceTemplate(stack)
	let l:template = {"type": "template", "children": []}
	while (!empty(a:stack))
		call insert(l:template["children"], remove(a:stack, -1))
	endwhile
	call add(a:stack, l:template)
	return a:stack
endfunc

func! vmustache#DumpTemplate(template)
	call vmustache#DumpNode(a:template, 0)
endfunc

func! vmustache#DumpNode(node, indent)
	if (a:node["type"] == "template")
		call vmustache#Dump("Template", a:indent)
		call vmustache#DumpChildren(a:node["children"], a:indent)
	elseif (a:node["type"] == "section")
		call vmustache#Dump("Section '" . a:node["name"] . "'", a:indent)
		call vmustache#DumpChildren(a:node["children"], a:indent)
	elseif (a:node["type"] == "var_escaped")
		call vmustache#Dump("Variable '" . a:node["name"] . "'", a:indent)
	elseif (a:node["type"] == "text")
		call vmustache#Dump("Text '" . a:node["value"] . "'", a:indent)
	endif
endfunc

func! vmustache#Dump(text, indent)
	echo repeat("  ", a:indent) . a:text
endfunc

func! vmustache#DumpChildren(children, indent)
	let l:indent = a:indent + 1
	for child in a:children
		call vmustache#DumpNode(child, l:indent)
	endfor
endfunc

"""""""""
" Render
"""""""""

func! vmustache#Render(node, data)
	let l:result = ""
	if (a:node["type"] == "template")
		let l:result = l:result . vmustache#RenderBlock(a:node, a:data)
	elseif (a:node["type"] == "section")
		let l:result = l:result . vmustache#RenderSection(a:node, a:data)
	elseif (a:node["type"] == "var_escaped")
		let l:result = l:result . vmustache#RenderVariable(a:node, a:data)
	elseif (a:node["type"] == "text")
		let l:result = l:result . vmustache#RenderText(a:node, a:data)
	else
		throw "Unknown node: " . string(a:node)
	endif
	return l:result
endfunc

func! vmustache#RenderBlock(block, data)
	let l:result = ""
	for child in a:block["children"]
		if (has_key(child, "name") && has_key(a:data, child["name"]))
			let l:result = l:result . vmustache#Render(child, a:data[child["name"]])
		else
			let l:result = l:result . vmustache#Render(child, [])
		endif
	endfor
	return result
endfunc

func! vmustache#RenderSection(section, data)
	let l:result = ""
	if (type(a:data) != 3)
		let l:data = [a:data]
	else
		let l:data = a:data
	endif
	for l:element in l:data
		let l:result = l:result . vmustache#RenderBlock(a:section, l:element)
	endfor
	return l:result
endfunc

func! vmustache#RenderVariable(variable, data)
	" return "<data>" . a:data . "</data>"
	" return string(a:data)
	return a:data
endfunc

func! vmustache#RenderText(node, data)
	" return "<text>" . a:node["value"] . "</text>"
	return a:node["value"]
endfunc
