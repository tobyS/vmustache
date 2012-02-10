let tagmap = {}
let tagmap["{{#"] = "section_start"
let tagmap["{{/"] = "section_end"
let tagmap["{{&"] = "var_unescaped"
let tagmap["{{!"] = "comment"
let tagmap["{{[^#/&!]"]  = "var_escaped"

" TODO: Not supported are inverted sections and partials

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
