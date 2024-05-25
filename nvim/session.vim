let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/.config/nvim
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +6 init.lua
badd +44 lua/perin/options.lua
badd +1 man://vim(1)
badd +32 lua/perin/keymaps.lua
badd +9 lua/perin/themes.lua
badd +79 lua/perin/plugins.lua
badd +1 lua/perin
badd +9 lua/perin/plugin_config/init.lua
badd +1 lua/perin/plugin_config/nvim_lspconfig.lua
badd +1 lua/perin/plugin_config
badd +15 lua/perin/plugin_config/neodev.lua
badd +62 lua/perin/plugin_config/clangd_extensions.lua
badd +87 lua/perin/plugin_config/nvim_cmp.lua
badd +10 test.c
argglobal
%argdel
$argadd init.lua
edit lua/perin/plugins.lua
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
wincmd _ | wincmd |
split
1wincmd k
wincmd w
let &splitbelow = s:save_splitbelow
let &splitright = s:save_splitright
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe 'vert 1resize ' . ((&columns * 80 + 80) / 160)
exe '2resize ' . ((&lines * 6 + 22) / 45)
exe 'vert 2resize ' . ((&columns * 79 + 80) / 160)
exe '3resize ' . ((&lines * 36 + 22) / 45)
exe 'vert 3resize ' . ((&columns * 79 + 80) / 160)
argglobal
balt init.lua
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 79 - ((31 * winheight(0) + 21) / 43)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 79
normal! 035|
lcd ~/.config/nvim
wincmd w
argglobal
if bufexists(fnamemodify("~/.config/nvim/lua/perin/plugin_config/init.lua", ":p")) | buffer ~/.config/nvim/lua/perin/plugin_config/init.lua | else | edit ~/.config/nvim/lua/perin/plugin_config/init.lua | endif
if &buftype ==# 'terminal'
  silent file ~/.config/nvim/lua/perin/plugin_config/init.lua
endif
balt ~/.config/nvim/init.lua
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 8 - ((4 * winheight(0) + 3) / 6)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 8
normal! 0
lcd ~/.config/nvim
wincmd w
argglobal
if bufexists(fnamemodify("~/.config/nvim/init.lua", ":p")) | buffer ~/.config/nvim/init.lua | else | edit ~/.config/nvim/init.lua | endif
if &buftype ==# 'terminal'
  silent file ~/.config/nvim/init.lua
endif
balt ~/.config/nvim/lua/perin/themes.lua
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 13 - ((12 * winheight(0) + 18) / 36)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 13
normal! 05|
lcd ~/.config/nvim
wincmd w
exe 'vert 1resize ' . ((&columns * 80 + 80) / 160)
exe '2resize ' . ((&lines * 6 + 22) / 45)
exe 'vert 2resize ' . ((&columns * 79 + 80) / 160)
exe '3resize ' . ((&lines * 36 + 22) / 45)
exe 'vert 3resize ' . ((&columns * 79 + 80) / 160)
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let &winminheight = s:save_winminheight
let &winminwidth = s:save_winminwidth
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
nohlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
