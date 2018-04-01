if exists("g:autoloaded_refract") | finish | endif
let g:autoloaded_refract = 1

func! refract#if_match(patterns, x, y)
  return s:is_match(a:patterns) ? a:x : a:y
endf

func! refract#if_cmd_match(patterns, x, y)
  return (s:is_cmd() && s:is_match(a:patterns)) ? a:x : a:y
endf

func! refract#if_end(x, y)
  return s:is_end() ? a:x : a:y
endf

func! refract#if_incsearch(x, y)
  return (&incsearch && s:is_search()) ? a:x : a:y
endf

func! s:is_cmd()
  return getcmdtype() == ':'
endf

func! s:is_end()
  return getcmdpos() > strchars(getcmdline())
endf

func! s:is_search()
  let x = getcmdtype()
  return x == '/' || x == '?'
endf

func! s:is_match(patterns)
  let cmdline = getcmdline()

  if getcmdpos() > strchars(cmdline)
    for p in a:patterns
      if match(cmdline, p) != -1
        return 1
      endif
    endfor
  endif

  return 0
endf
