if exists("g:loaded_refract") | finish | endif
let g:loaded_refract = 1

" Plug map usage:
"
" cmap   :   <Plug>(refract_colon_recall)
" cmap   ;   <Plug>(refract_semicolon_recall)
" cmap   s   <Plug>(refract_autoreturn_ls_vs)
" cmap <C-N> <Plug>(refract_incsearch_next)
" cmap <C-P> <Plug>(refract_incsearch_prev)
" cmap <C-D> <Plug>(refract_delete)

cnoremap <expr> <Plug>(refract_colon_recall)
\ refract#if_cmd_match(['^$', "^'<,'>$"], "\<Up>", ':')

cnoremap <expr> <Plug>(refract_semicolon_recall)
\ refract#if_cmd_match(['^$', "^'<,'>$"], "\<Up>", ';')

cnoremap <expr> <Plug>(refract_autoreturn_ls_vs)
\ refract#if_cmd_match(['^l$', '^v$'], "s\<CR>", 's')

cnoremap <expr> <Plug>(refract_incsearch_next)
\ refract#if_incsearch("\<C-G>", "\<Down>")

cnoremap <expr> <Plug>(refract_incsearch_prev)
\ refract#if_incsearch("\<C-T>", "\<Up>")

cnoremap <expr> <Plug>(refract_delete)
\ refract#if_end("\<C-D>", "\<Del>")
