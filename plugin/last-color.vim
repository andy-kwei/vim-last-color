" Exit if vi compatible or plugin loaded
if &cp || exists('g:loaded_last_color')
  finish
endif
let g:loaded_last_color = 1

" Store color info file in the plugin directory
if !exists('g:color_info_filepath')
  let g:color_info_filepath = escape(expand('<sfile>:p:h:h'), '\') . '/.color_info'
endif

function! LoadLastColor()
  " Source color info file if it exists
  if filereadable(g:color_info_filepath)
    exec 'source ' . g:color_info_filepath
    return
  endif
  " Fall back to color settings from user config defaults
  if exists('g:last_color_default_colorscheme')
    exec 'colorscheme ' . g:last_color_default_colorscheme
  endif
  if exists('g:last_color_default_background')
    exec 'set background=' . g:last_color_default_background
  endif
endfunction

function! SaveLastColor()
  " Not much we can do if g:colors_name is not set
  if !exists('g:colors_name')
    return
  endif
  " Save current colorscheme related settings to color info file
  let color_info = ['set background=' . &background, 'colorscheme ' . g:colors_name]
  call writefile(color_info, g:color_info_filepath)
endfunction

" Autocommands to load and save color settings
augroup last_colors
  autocmd!
  autocmd VimEnter * call LoadLastColor()
  " Note that setting background also causes colorscheme to reload
  autocmd Colorscheme * call SaveLastColor()
augroup END
