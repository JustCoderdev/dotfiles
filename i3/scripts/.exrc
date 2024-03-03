let s:cpo_save=&cpo
set cpo&vim
imap <C-G>S <Plug>ISurround
imap <C-G>s <Plug>Isurround
imap <C-S> <Plug>Isurround
inoremap <silent> <Plug>(ale_complete) :ALEComplete
inoremap <silent> <C-C> 
inoremap <silent> <S-Right> <Nop>
inoremap <silent> <S-Left> <Nop>
inoremap <silent> <S-Down> <Nop>
inoremap <silent> <S-Up> <Nop>
inoremap <silent> <Right> <Nop>
inoremap <silent> <Left> <Nop>
inoremap <silent> <M-j> <Nop>
inoremap <silent> <M-k> <Nop>
inoremap <C-W> u
inoremap <C-U> u
nnoremap <silent>  zz
tnoremap <silent>   h
nnoremap <silent>  h
tnoremap <silent> <NL>  j
nnoremap <silent> <NL> j
tnoremap <silent>   k
nnoremap <silent>  k
tnoremap <silent>   l
nnoremap <silent>  l
nnoremap <silent>  zz
nnoremap <silent> q :q 
nnoremap <silent> h s
tnoremap <silent>  
xmap <silent>  s :StripWhitespace
nnoremap <silent>  o :SymbolsOutline 
nnoremap <silent>  e :Lexplore 25 
vnoremap <silent>  P "+P :echo "Pasted from system clipboard" 
nnoremap <silent>  P "+P :echo "Pasted from system clipboard" 
vnoremap <silent>  p "+p :echo "Pasted from system clipboard" 
nnoremap <silent>  p "+p :echo "Pasted from system clipboard" 
nnoremap <silent>  Y "+yg_ :echo "Yanked to system clipboard" 
nnoremap <silent>  yy "+yy :echo "Yanked to system clipboard" 
vnoremap <silent>  y "+y   :echo "Yanked to system clipboard" 
nnoremap <silent>  y "+y   :echo "Yanked to system clipboard" 
nnoremap <silent>  G :FzfLua grep resume=true 
nnoremap <silent>  g :FzfLua grep 
nnoremap <silent>  H :FzfLua files resume=true 
nnoremap <silent>  h :FzfLua files 
nnoremap <silent>  s :StripWhitespace 
nnoremap <silent>  m :mksession! .session.vim  :echo "Updated session file" 
nnoremap <silent>  u :w  :source % :echo "Sourced current file" 
nnoremap <silent>  qq :wall  :mksession! .old_session.vim  :qall 
nnoremap <silent>  ww :wall  :echo "Saved all files" 
nnoremap <silent>  rs :%s/\<\>//gI<Left><Left><Left>
nnoremap <silent>   <Nop>
xnoremap # y?\V"
omap <silent> % <Plug>(MatchitOperationForward)
xmap <silent> % <Plug>(MatchitVisualForward)
nmap <silent> % <Plug>(MatchitNormalForward)
nnoremap & :&&
nnoremap <silent> ' <Nop>
xnoremap * y/\V"
vnoremap <silent> < <gv
vnoremap <silent> > >gv
nnoremap <silent> J J0
nnoremap <silent> Q <Nop>
xmap S <Plug>VSurround
nnoremap Y y$
omap <silent> [% <Plug>(MatchitOperationMultiBackward)
xmap <silent> [% <Plug>(MatchitVisualMultiBackward)
nmap <silent> [% <Plug>(MatchitNormalMultiBackward)
omap <silent> ]% <Plug>(MatchitOperationMultiForward)
xmap <silent> ]% <Plug>(MatchitVisualMultiForward)
nmap <silent> ]% <Plug>(MatchitNormalMultiForward)
xmap a% <Plug>(MatchitVisualTextObject)
nmap cS <Plug>CSurround
nmap cs <Plug>Csurround
nmap ds <Plug>Dsurround
xmap gS <Plug>VgSurround
vmap <silent> gL <Plug>VLionLeft
nmap <silent> gL <Plug>LionLeft
vmap <silent> gl <Plug>VLionRight
nmap <silent> gl <Plug>LionRight
nmap gcu <Plug>Commentary<Plug>Commentary
nmap gcc <Plug>CommentaryLine
omap gc <Plug>Commentary
nmap gc <Plug>Commentary
xmap gc <Plug>Commentary
xmap gx <Plug>NetrwBrowseXVis
nmap gx <Plug>NetrwBrowseX
omap <silent> g% <Plug>(MatchitOperationBackward)
xmap <silent> g% <Plug>(MatchitVisualBackward)
nmap <silent> g% <Plug>(MatchitNormalBackward)
xnoremap <silent> p "_dP
nmap ySS <Plug>YSsurround
nmap ySs <Plug>YSsurround
nmap yss <Plug>Yssurround
nmap yS <Plug>YSurround
nmap ys <Plug>Ysurround
snoremap <expr> <BS> ("\<BS>" . (&virtualedit ==# '' && getcurpos()[2] >= col('$') - 1 ? 'a' : 'i'))
nnoremap <silent> <Plug>SurroundRepeat .
nnoremap <silent> <Plug>LionRepeat .
nmap <silent> <Plug>CommentaryUndo :echoerr "Change your <Plug>CommentaryUndo map to <Plug>Commentary<Plug>Commentary"
tnoremap <silent> <Plug>(fzf-normal) 
tnoremap <silent> <Plug>(fzf-insert) i
nnoremap <silent> <Plug>(fzf-normal) <Nop>
nnoremap <silent> <Plug>(fzf-insert) i
nnoremap <silent> <Plug>(ale_info_preview) :ALEInfo -preview
nnoremap <silent> <Plug>(ale_info_clipboard) :ALEInfo -clipboard
nnoremap <silent> <Plug>(ale_info_echo) :ALEInfo -echo
nnoremap <silent> <Plug>(ale_info) :ALEInfo
nnoremap <silent> <Plug>(ale_repeat_selection) :ALERepeatSelection
nnoremap <silent> <Plug>(ale_code_action) :ALECodeAction
nnoremap <silent> <Plug>(ale_filerename) :ALEFileRename
nnoremap <silent> <Plug>(ale_rename) :ALERename
nnoremap <silent> <Plug>(ale_import) :ALEImport
nnoremap <silent> <Plug>(ale_documentation) :ALEDocumentation
nnoremap <silent> <Plug>(ale_hover) :ALEHover
nnoremap <silent> <Plug>(ale_find_references) :ALEFindReferences
nnoremap <silent> <Plug>(ale_go_to_implementation_in_vsplit) :ALEGoToImplementation -vsplit
nnoremap <silent> <Plug>(ale_go_to_implementation_in_split) :ALEGoToImplementation -split
nnoremap <silent> <Plug>(ale_go_to_implementation_in_tab) :ALEGoToImplementation -tab
nnoremap <silent> <Plug>(ale_go_to_implementation) :ALEGoToImplementation
nnoremap <silent> <Plug>(ale_go_to_type_definition_in_vsplit) :ALEGoToTypeDefinition -vsplit
nnoremap <silent> <Plug>(ale_go_to_type_definition_in_split) :ALEGoToTypeDefinition -split
nnoremap <silent> <Plug>(ale_go_to_type_definition_in_tab) :ALEGoToTypeDefinition -tab
nnoremap <silent> <Plug>(ale_go_to_type_definition) :ALEGoToTypeDefinition
nnoremap <silent> <Plug>(ale_go_to_definition_in_vsplit) :ALEGoToDefinition -vsplit
nnoremap <silent> <Plug>(ale_go_to_definition_in_split) :ALEGoToDefinition -split
nnoremap <silent> <Plug>(ale_go_to_definition_in_tab) :ALEGoToDefinition -tab
nnoremap <silent> <Plug>(ale_go_to_definition) :ALEGoToDefinition
nnoremap <silent> <Plug>(ale_fix) :ALEFix
nnoremap <silent> <Plug>(ale_detail) :ALEDetail
nnoremap <silent> <Plug>(ale_lint) :ALELint
nnoremap <silent> <Plug>(ale_reset_buffer) :ALEResetBuffer
nnoremap <silent> <Plug>(ale_disable_buffer) :ALEDisableBuffer
nnoremap <silent> <Plug>(ale_enable_buffer) :ALEEnableBuffer
nnoremap <silent> <Plug>(ale_toggle_buffer) :ALEToggleBuffer
nnoremap <silent> <Plug>(ale_reset) :ALEReset
nnoremap <silent> <Plug>(ale_disable) :ALEDisable
nnoremap <silent> <Plug>(ale_enable) :ALEEnable
nnoremap <silent> <Plug>(ale_toggle) :ALEToggle
nnoremap <silent> <Plug>(ale_last) :ALELast
nnoremap <silent> <Plug>(ale_first) :ALEFirst
nnoremap <silent> <Plug>(ale_next_wrap_warning) :ALENext -wrap -warning
nnoremap <silent> <Plug>(ale_next_warning) :ALENext -warning
nnoremap <silent> <Plug>(ale_next_wrap_error) :ALENext -wrap -error
nnoremap <silent> <Plug>(ale_next_error) :ALENext -error
nnoremap <silent> <Plug>(ale_next_wrap) :ALENextWrap
nnoremap <silent> <Plug>(ale_next) :ALENext
nnoremap <silent> <Plug>(ale_previous_wrap_warning) :ALEPrevious -wrap -warning
nnoremap <silent> <Plug>(ale_previous_warning) :ALEPrevious -warning
nnoremap <silent> <Plug>(ale_previous_wrap_error) :ALEPrevious -wrap -error
nnoremap <silent> <Plug>(ale_previous_error) :ALEPrevious -error
nnoremap <silent> <Plug>(ale_previous_wrap) :ALEPreviousWrap
nnoremap <silent> <Plug>(ale_previous) :ALEPrevious
xnoremap <silent> <Plug>NetrwBrowseXVis :call netrw#BrowseXVis()
nnoremap <silent> <Plug>NetrwBrowseX :call netrw#BrowseX(netrw#GX(),netrw#CheckIfRemote(netrw#GX()))
xmap <silent> <Plug>(MatchitVisualTextObject) <Plug>(MatchitVisualMultiBackward)o<Plug>(MatchitVisualMultiForward)
onoremap <silent> <Plug>(MatchitOperationMultiForward) :call matchit#MultiMatch("W",  "o")
onoremap <silent> <Plug>(MatchitOperationMultiBackward) :call matchit#MultiMatch("bW", "o")
xnoremap <silent> <Plug>(MatchitVisualMultiForward) :call matchit#MultiMatch("W",  "n")m'gv``
xnoremap <silent> <Plug>(MatchitVisualMultiBackward) :call matchit#MultiMatch("bW", "n")m'gv``
nnoremap <silent> <Plug>(MatchitNormalMultiForward) :call matchit#MultiMatch("W",  "n")
nnoremap <silent> <Plug>(MatchitNormalMultiBackward) :call matchit#MultiMatch("bW", "n")
onoremap <silent> <Plug>(MatchitOperationBackward) :call matchit#Match_wrapper('',0,'o')
onoremap <silent> <Plug>(MatchitOperationForward) :call matchit#Match_wrapper('',1,'o')
xnoremap <silent> <Plug>(MatchitVisualBackward) :call matchit#Match_wrapper('',0,'v')m'gv``
xnoremap <silent> <Plug>(MatchitVisualForward) :call matchit#Match_wrapper('',1,'v'):if col("''") != col("$") | exe ":normal! m'" | endifgv``
nnoremap <silent> <Plug>(MatchitNormalBackward) :call matchit#Match_wrapper('',0,'n')
nnoremap <silent> <Plug>(MatchitNormalForward) :call matchit#Match_wrapper('',1,'n')
tnoremap <silent> <C-L>  l
tnoremap <silent> <C-K>  k
tnoremap <silent> <C-J>  j
tnoremap <silent> <C-H>  h
nnoremap <silent> <C-S-Right> :vertical resize +2 
nnoremap <silent> <C-S-Left> :vertical resize -2 
nnoremap <silent> <C-S-Down> :resize +2 
nnoremap <silent> <C-S-Up> :resize -2 
nnoremap <silent> <C-K> k
nnoremap <silent> <C-J> j
nnoremap <silent> <C-H> h
nnoremap <silent> <C-U> zz
nnoremap <silent> <C-D> zz
nnoremap <silent> <C-W>q :q 
nnoremap <silent> <C-W>h s
xnoremap <silent> <S-Right> <Nop>
snoremap <silent> <S-Right> <Nop>
nnoremap <silent> <S-Right> <Nop>
xnoremap <silent> <S-Left> <Nop>
snoremap <silent> <S-Left> <Nop>
nnoremap <silent> <S-Left> <Nop>
xnoremap <silent> <S-Down> <Nop>
snoremap <silent> <S-Down> <Nop>
nnoremap <silent> <S-Down> <Nop>
xnoremap <silent> <S-Up> <Nop>
snoremap <silent> <S-Up> <Nop>
nnoremap <silent> <S-Up> <Nop>
xnoremap <silent> <Right> <Nop>
snoremap <silent> <Right> <Nop>
nnoremap <silent> <Right> <Nop>
xnoremap <silent> <Left> <Nop>
snoremap <silent> <Left> <Nop>
nnoremap <silent> <Left> <Nop>
xnoremap <silent> <Down> <Nop>
snoremap <silent> <Down> <Nop>
nnoremap <silent> <Down> <Nop>
xnoremap <silent> <Up> <Nop>
snoremap <silent> <Up> <Nop>
nnoremap <silent> <Up> <Nop>
nnoremap <silent> <C-L> l
inoremap <silent>  
imap S <Plug>ISurround
imap s <Plug>Isurround
inoremap <expr>  v:lua.require'nvim-autopairs'.completion_confirm()
imap  <Plug>Isurround
inoremap  u
inoremap  u
let &cpo=s:cpo_save
unlet s:cpo_save
set cindent
set cinoptions=l1,g0,t0
set helplang=en
set nohlsearch
set laststatus=3
set menuitems=8
set mouse=
set operatorfunc=<SNR>37_go
set runtimepath=~/.config/nvim,/etc/xdg/nvim,~/.local/share/nvim/site,~/.local/share/nvim/site/pack/*/start/*,/usr/local/share/nvim/site,/usr/share/nvim/site,/usr/local/share/nvim/runtime,/usr/local/share/nvim/runtime/pack/dist/opt/matchit,/usr/local/lib/nvim,~/.local/share/nvim/site/pack/*/start/*/after,/usr/share/nvim/site/after,/usr/local/share/nvim/site/after,~/.local/share/nvim/site/after,/etc/xdg/nvim/after,~/.config/nvim/after,~/.cache/nvim/parsers
set scrolloff=8
set shiftwidth=4
set noshowmode
set sidescrolloff=15
set smartindent
set statusline=%#Normal#
set tabstop=4
set termguicolors
set window=29
" vim: set ft=vim :
