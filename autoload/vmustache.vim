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
			if (l:lastindex + 1 != l:matchstart)
				call add(l:tokens, vmustache#ExtractTextToken(a:text, l:lastindex + 1, l:matchstart))
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
		endif
	endfor
	let l:stack = vmustache#ReduceTemplate(l:stack)
	return l:stack[0]
endfunc

func! vmustache#ReduceSection(stack)
	let l:endtoken = remove(a:stack, -1)
	let l:section = {"type": "section", "name": l:endtoken["value"], "children": []}
	while (!empty(a:stack))
		let l:token = remove(a:stack, -1)
		if (l:token["type"] == "section_start" && l:token["value"] == l:endtoken["value"])
			break
		endif
		call insert(l:section["children"], l:token)
	endwhile
	call add(a:stack, l:section)
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
		call vmustache#Dump("Variable '" . a:node["value"] . "'", a:indent)
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
