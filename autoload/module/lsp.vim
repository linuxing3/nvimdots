"======================================================================
"
" lsp.vim - 
"
" Created by skywind on 2023/08/29
" Last Modified: 2023/08/29 17:10:58
"
"======================================================================


"----------------------------------------------------------------------
" check type
"----------------------------------------------------------------------
function! module#lsp#type()
	if exists(':YcmCompleter')
		return 'ycm'
	elseif exists(':CocInstall')
		return 'coc'
	elseif exists(':CmpStatus')
		return 'cmp'
	endif
	return ''
endfunc


"----------------------------------------------------------------------
" hover
"----------------------------------------------------------------------
function! module#lsp#hover() abort
	let tt = module#lsp#type()
	if tt == 'coc'
		if CocAction('hasProvider', 'hover')
			call CocActionAsync('doHover')
		elseif &ft == 'vim'
			call feedkeys('K', 'ni')
		endif
	elseif tt == 'ycm'
		exec "normal \<Plug>(YCMHover)"
	elseif tt == 'cmp'
		lua vim.lsp.buf.hover()
	endif
endfunc


"----------------------------------------------------------------------
" signature help
"----------------------------------------------------------------------
function! module#lsp#signature_help() abort
	let tt = module#lsp#type()
	if tt == 'coc'
	elseif tt == 'cmp'
		lua vim.lsp.buf.signature_help()
	endif
endfunc


"----------------------------------------------------------------------
" get doc
"----------------------------------------------------------------------
function! module#lsp#get_document() abort
	let tt = module#lsp#type()
	if tt == 'ycm'
		exec 'YcmCompleter GetDoc'
	elseif tt == 'ycm'
	endif
endfunc


"----------------------------------------------------------------------
" 
"----------------------------------------------------------------------
function! module#lsp#get_type() abort
	let tt = module#lsp#type()
	if tt == 'ycm'
	elseif tt == 'coc'
	endif
endfunc


