# refract

This plugin provides functions for building conditional `cmap` expressions based on the current cmdline context.
It also includes some `<Plug>` maps I've found useful.

### Usage

Several `<Plug>` maps are provided. I use them like so:
``` vim
" When typed at an empty cmdline, : recalls previous Ex command.
" From Normal/Visual mode, type :: to quickly recall last Ex command.
cmap   :   <Plug>(refract_colon_recall)

" If you also map ; to : you can type ;; to enter Ex mode
" and recall the previous Ex command
cmap   ;   <Plug>(refract_semicolon_recall)

" Run ls or vs Ex commands without having to type a terminating <CR>
cmap   s   <Plug>(refract_autoreturn_ls_vs)

" Use <C-N>/<C-P> to jump to the next/previous incsearch match
cmap <C-N> <Plug>(refract_incsearch_next)
cmap <C-P> <Plug>(refract_incsearch_prev)

" Map <C-D> to <Delete> unless at the end of the line, in which case use its default behavior
cmap <C-D> <Plug>(refract_delete)
```

### Motivation

Some keybindings only make sense in certain contexts, like during incremental search.
We can use `<expr>` maps to vary a key's behavior according to some condition:
``` vim
" Use <C-N>/<C-P> to jump to the next/previous incsearch match
cnoremap <expr> <C-N> getcmdtype() == '/' ? "\<C-G>" : "\<C-N>"
cnoremap <expr> <C-P> getcmdtype() == '/' ? "\<C-T>" : "\<C-P>"
```

There are also some Ex commands that I run frequently enough to want a streamlined keybinding.
But I want the mapping to bear some resemblance to the original command.
Listing buffers with `:ls` is a good example.
Since I map `;` to `:`, typing `;ls` is very fast and natural, but I still have to reach for <kbd>Enter</kbd> to actually run it.
I could do:
``` vim
nnoremap ;ls :ls<CR>
```
but this introduces `timeout` lag. If I type `;` to enter Ex mode, Vim waits to see if `ls` will follow.
I can instead do:
``` vim
cnoremap <expr> s (match(getcmdline(), '^l$') != -1) ? "s\<CR>" : 's'
```
This makes the final key in the `;ls` sequence act as the trigger.
Both `;` and `l` are processed normally, but when Vim sees an `s` in Ex mode, it checks whether it's the final key in an `ls` command, and if so, appends `<CR>`.

### Library Functions

The functions in this plugin expand on the above ideas.
You can match against mutliple patterns and vary behavior based on command type, command-line contents, and cursor position within the command-line.

``` vim
" If getcmdline() matches any of patterns, return x, else return y
refract#if_match(patterns, x, y)

" If getcmdtype() == ':' and getcmdline() matches any of patterns, return x, else return y
refract#if_cmd_match(patterns, x, y)

" If cursor is at the end of cmdline, return x, else return y
refract#if_end(x, y)

" If performing an incremental search, return x, else return y
refract#if_incsearch(x, y)
```

### Plug maps

``` vim
" If cmdline is currently empty or contains only a visual range ('<'>), recall the previous Ex command, otherwise map to :
<Plug>(refract_colon_recall)

" Same as <Plug>(refract_colon_recall), but will map to ; rather than :
" Useful if you map ; to :
<Plug>(refract_semicolon_recall)

" Run :ls or :vs Ex commands without having to hit <CR>
<Plug>(refract_autoreturn_ls_vs)

" If performing an incremental search, jump to next match, otherwise map to <Down>
<Plug>(refract_incsearch_next)

" If performing an incremental search, jump to previous match, otherwise map to <Up>
<Plug>(refract_incsearch_prev)

" If there are any characters to the right of the cursor, map to <Delete>
" Otherwise (at the end of the cmdline), map to <C-D> (triggering file/directory completion).
<Plug>(refract_delete)
```
