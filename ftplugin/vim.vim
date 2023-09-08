if &modifiable
	set ff=unix
endif

let b:cursorword = 1

let b:navigator_insert = {}
let b:navigator_insert.i = {
			\ 'i': [':CodeSnipExpand windows', 'windows-checker'],
			\ 's': [':CodeSnipExpand scripthome', 'script-home-detector'],
			\ 't': [':CodeSnipExpand try', 'insert-try-catch'],
			\ 'w': [':CodeSnipExpand while', 'insert-while-endwhile'],
			\ }

	
