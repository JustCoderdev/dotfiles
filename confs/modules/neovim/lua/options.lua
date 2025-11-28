declare_file("options")

-- All options available on
-- Fullref <https://neovim.io/doc/user/options.html>
-- Quickref <https://neovim.io/doc/user/quickref.html>

vim.opt.autochdir = true                -- change directory to the file in the current window
vim.opt.autoindent = true               -- take indent for new line from previous line
vim.opt.background = "dark"             -- "dark" or "light", used for highlight colors

vim.opt.breakindent = true              -- wrapped line repeats indent
vim.opt.breakindentopt = "shift:6"      -- settings for 'breakindent'

vim.opt.cindent = true                  -- do C program indenting
vim.opt.cinoptions = "=1s,t0,#0,P1"     -- how to do indenting when 'cindent' is set
vim.opt.cinkeys = "0{,0},0),0],:,0#,!^F,o,O,e"

vim.opt.clipboard = ""                  -- use the clipboard as the unnamed register
vim.opt.colorcolumn = "80"              -- columns to highlight

vim.opt.cpoptions = "I"                 -- flags for Vi-compatible behavior

vim.opt.cursorcolumn = false            -- highlight the screen column of the cursor
vim.opt.cursorline = true               -- highlight the screen line of the cursor
vim.opt.cursorlineopt = "line,number"   -- settings for 'cursorline'

vim.opt.display = "uhex"                -- all unprintable characters are displayed as <xx>
vim.opt.expandtab = false               -- use spaces when <Tab> is inserted

vim.opt.hlsearch = true                 -- highlight matches with last search pattern
vim.opt.ignorecase = true               -- ignore case in search patterns
vim.opt.incsearch = true                -- highlight match while typing search pattern

vim.opt.list = true
vim.opt.listchars = {
	tab = '> ',
	-- eol = '$',
	space = '·' -- •
}

vim.opt.matchpairs = "(:),{:},[:],<:>" -- characters that form pairs
vim.opt.menuitems = 4                  -- maximum number of items in a menu

vim.opt.mouse = "nvi"                  -- enable the use of mouse clicks
vim.opt.mousefocus = true              -- keyboard focus follows the mouse
vim.opt.mousehide = true               -- hide mouse pointer while typing
vim.opt.mousemodel = "extend"          -- set the model to use for the mouse
vim.opt.mousescroll = "ver:1,hor:2"    -- set by how much the mousewheel will scroll

vim.opt.number = true                  -- print the line number in front of each line
vim.opt.numberwidth = 4                -- number of columns used for the line number
vim.opt.relativenumber = true          -- show relative line number in front of each line

vim.opt.scrolloff = 8                  -- minimum nr. of lines above and below cursor
vim.opt.showmode = false               -- message on status line to show current mode
vim.opt.sidescrolloff = 15             -- min. nr. of columns to left and right of cursor

-- vim.opt.smartindent = true             -- smart autoindenting for C programs
vim.opt.smarttab = true                -- use 'shiftwidth' when inserting <Tab>
vim.opt.shiftwidth = 0                 -- Number of spaces to use for each step of (auto)indent (0 to use tabstop)
vim.opt.softtabstop = -1               -- number of spaces that <Tab> uses while editing
vim.opt.tabstop = 4                    -- number of spaces that <Tab> in file uses
vim.opt.termguicolors = COLOR_CAPABLE  -- whether the terminal is color capable

vim.opt.wrap = false                   -- long lines wrap and continue on the next line


-- Extra options
-- #----------------------------------------------------------# --

-- :h c.vim
vim.cmd("au BufRead,BufNewFile *.h set filetype=c")
vim.cmd("let g:loaded_python3_provider = 0")
vim.cmd("let g:loaded_ruby_provider = 0")
vim.cmd("let g:loaded_perl_provider = 0")

vim.cmd("hi ExtraWhitespace ctermbg=red") -- vim-better-whitespace
vim.cmd("let g:lion_squeeze_spaces = 1")  -- vim-lion

-- vim.cmd("hi SpecialKey guibg=#ff0000 guifg=#000000 gui=NONE")
-- vim.cmd("hi Whitespace guibg=#ff0000 guifg=#ffffff gui=NONE")


