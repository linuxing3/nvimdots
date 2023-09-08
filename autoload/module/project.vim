"======================================================================
"
" project.vim - 
"
" Created by skywind on 2023/07/03
" Last Modified: 2023/07/03 15:43:47
"
"======================================================================


"----------------------------------------------------------------------
" get path
"----------------------------------------------------------------------
function! module#project#path(path) abort
	let r = asclib#path#get_root('%')
	let p = asclib#path#join(r, a:path)
	return asclib#path#normalize(p)
endfunc


"----------------------------------------------------------------------
" check exists
"----------------------------------------------------------------------
function! module#project#exists(path) abort
	let p = module#project#path(a:path)
	return asclib#path#exists(p)
endfunc


"----------------------------------------------------------------------
" open file
"----------------------------------------------------------------------
function! module#project#open(name) abort
	let p = module#project#path(a:name)
	call asclib#utils#file_switch(['-switch=useopen,auto', p])
endfunc


"----------------------------------------------------------------------
" open if exists
"----------------------------------------------------------------------
function! module#project#try_open(name) abort
	let p = module#project#path(a:name)
	if asclib#path#exists(p)
		call asclib#utils#file_switch(['-switch=useopen,auto', p])
	else
		call asclib#common#errmsg('ERROR: cannot open ' . p)
	endif
endfunc


