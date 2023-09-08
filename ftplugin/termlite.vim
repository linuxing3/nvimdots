"======================================================================
"
" termlite.vim - 
"
" Created by skywind on 2023/08/03
" Last Modified: 2023/08/03 06:33:11
"
"======================================================================

if &bt != 'terminal'
	finish
endif


"----------------------------------------------------------------------
" basic 
"----------------------------------------------------------------------
tnoremap <buffer><tab><tab> <tab>
tnoremap <buffer><tab>h <c-\><c-n><c-w>h
tnoremap <buffer><tab>j <c-\><c-n><c-w>j
tnoremap <buffer><tab>k <c-\><c-n><c-w>k
tnoremap <buffer><tab>l <c-\><c-n><c-w>l

if !has('nvim')
	tnoremap <buffer><c-w> <c-_>
	tnoremap <buffer>: <c-_>:
else
	tnoremap <buffer><c-w> <c-\><c-n><c-w>
	tnoremap <buffer>: <c-\><c-n>:
endif


"----------------------------------------------------------------------
" auto insert
"----------------------------------------------------------------------
function! s:buffer_enter()
	" unsilent echom "haha1"
	if &bt == 'terminal'
		if &ft == 'termlite'
			if mode() != 't'
				call feedkeys('i')
			endif
		endif
	endif
endfunc


"----------------------------------------------------------------------
" 
"----------------------------------------------------------------------
augroup TermLiteGroup
	au!
	au WinEnter * call s:buffer_enter()
augroup END


