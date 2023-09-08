"======================================================================
"
" cpp.vim - 
"
" Created by skywind on 2021/12/22
" Last Modified: 2021/12/22 22:23:49
"
"======================================================================


"----------------------------------------------------------------------
" switch header
"----------------------------------------------------------------------
function! module#cpp#switch_header(...)
	let l:main = expand('%:p:r')
	let l:fext = expand('%:e')
	if index(['c', 'cpp', 'm', 'mm', 'cc'], l:fext) >= 0
		let l:altnames = ['h', 'hpp', 'hh']
	elseif index(['h', 'hh', 'hpp'], l:fext) >= 0
		let l:altnames = ['c', 'cpp', 'cc', 'm', 'mm']
	elseif l:fext == '' && ft == 'cpp'
		let l:altnames = ['cpp', 'cc' ]
	else
		echo 'switch failed, not a c/c++ source'
		return 
	endif
	let found = ''
	for l:next in l:altnames
		let l:newname = l:main . '.' . l:next
		if filereadable(l:newname)
			let found = l:newname
			break
		endif
	endfor
	if found != ''
		let switch = (a:0 < 1)? '' : a:1
		let opts = {}
		if switch != ''
			let opts.switch = 'useopen,' . switch
		endif
		" unsilent echom opts
		call asclib#core#switch(found, opts)
	else
		let t = 'switch failed, can not find another part of c/c++ source'
		call asclib#core#errmsg(t)
	endif
endfunc


"----------------------------------------------------------------------
" insert a class name
"----------------------------------------------------------------------
function! module#cpp#class_insert(line1, line2)
	let msg = 'Enter a class name to insert: '
	let tag = expand('%:t:r')
	let clsname = asclib#ui#input(msg, tag, 'clsname')
	if clsname != ''
		let clsname = escape(clsname, '/\[*~^')
		let text = 's/\~\=\w\+\s*(/' . clsname . '::&/'
		exec a:line1 . ',' . a:line2 . text
	endif
endfunc


"----------------------------------------------------------------------
" expand brace
"----------------------------------------------------------------------
function! module#cpp#brace_expand(line1, line2)
	let cmd = 's/;\s*$/\r{\r}\r\r/'
	exec a:line1 . ',' . a:line2 . cmd
endfunc


"----------------------------------------------------------------------
" WhatFunctionAreWeIn()
"----------------------------------------------------------------------
function! module#cpp#function_name()
	let strList = ["while", "foreach", "ifelse", "if else", "for", "if"]
	let strList += ["else", "try", "catch", "case", "switch"]
	let foundcontrol = 1
	let position = ""
	let pos = getpos(".")          " This saves the cursor position
	let view = winsaveview()       " This saves the window view
	while (foundcontrol)
		let foundcontrol = 0
		normal [{
		call search('\S','bW')
		let tempchar = getline(".")[col(".") - 1]
		if (match(tempchar, ")") >=0 )
			normal %
			call search('\S','bW')
		endif
		let tempstring = getline(".")
		for item in strList
			if (match(tempstring,item) >= 0)
			let position = item . " - " . position
			let foundcontrol = 1
			break
	  endif
		endfor
		if foundcontrol == 0
		call cursor(pos)
		call winrestview(view)
		return tempstring.position
	endif
	endwhile
	call cursor(pos)
	call winrestview(view)
	return tempstring.position
endfunc


"----------------------------------------------------------------------
" copy function definition
"----------------------------------------------------------------------
function! module#cpp#copy_definition()
	let view = winsaveview()
	let pos = getcurpos()
	" Get class
	call search('^\s*\<class\>', 'b')
	exe 'normal ^w"zyw'
	let s:class = @z
	let l:ns = search('^\s*\<namespace\>', 'b')
	" Get namespace
	if l:ns != 0
		exe 'normal ^w"zyw'
		let s:namespace = asclib#string#strip(@z)
	else
		let s:namespace = ''
	endif
	" Go back to definition
	call setpos('.', pos)
	call winrestview(view)
	let text = getline('.')
	let text = substitute(text, '\/\*.*\*\/', '', 'g')
	let text = substitute(text, '\/\/.*$', '', 'g')
	let text = substitute(text, '^\s*', '', 'g')
	let text = substitute(text, ';[\r\n\t ]*$', '', 'g')
	let s:defline = text
	let g:defline = s:defline
	let comments = []
	let curline = line('.')
	let nextline = curline - 1
	while nextline > 0
		let text = getline(nextline)
		let text = asclib#string#strip(text)
		if text =~ '^\/\/'
			call add(comments, text)
		else
			break
		endif
		let nextline -= 1
	endwhile
	call reverse(comments)
	let s:fcomments = comments
endfunc


"----------------------------------------------------------------------
" paste imp
"----------------------------------------------------------------------
function! module#cpp#paste_implementation()
	if exists('s:defline') == 0
		return 0
	endif
	if len(s:fcomments) > 0
		call append(line('.') - 1, '')
		call append(line('.') - 1, '//' .. repeat('-', 69))
		for text in s:fcomments
			call append(line('.') - 1, text)
		endfor
		call append(line('.') - 1, '//' .. repeat('-', 69))
		exe 'normal k'
	endif
	call append('.', s:defline)
	exe 'normal j'
	" Remove keywords
	s/\<virtual\>\s*//e
	s/\<static\>\s*//e
	let s:namespace = ''
	if s:namespace == ''
		let l:classString = s:class . "::"
	else
		let l:classString = s:namespace . "::" . s:class . "::"
	endif
	if s:class == '' || &ft == 'c'
		let l:classString = ''
	endif
	" Remove default parameters
	s/\s\{-}=\s\{-}[^,)]\{1,}//e
	" Add class qualifier
	exe 'normal! ^f(bi' . l:classString
	stopinsert
	" Add brackets
	exe "normal! $o{\<CR>\<TAB>\<CR>}\<CR>"
	stopinsert
	exec "normal! kkkk"
	" Fix indentation
	exe 'normal! =4j^<4j'
	return 1
endfunc


