declare_file("options.lua")


vim.opt.autoindent = true             -- take indent for new line from previous line
vim.opt.background = "dark"           -- "dark" or "light", used for highlight colors

vim.opt.cindent = true                -- do C program indenting
vim.opt.cinoptions = "l1,g0,t0"       -- how to do indenting when 'cindent' is set

vim.opt.clipboard = ""                -- use the clipboard as the unnamed register
vim.opt.colorcolumn = "80"            -- columns to highlight

vim.opt.cursorcolumn = false          -- highlight the screen column of the cursor
vim.opt.cursorline = true             -- highlight the screen line of the cursor
vim.opt.cursorlineopt = "line,number" -- settings for 'cursorline'

vim.opt.expandtab = false             -- use spaces when <Tab> is inserted
-- vim.opt.filetype=c.doxygen		-- type of file, used for autocommands

vim.opt.hlsearch = false   -- highlight matches with last search pattern
vim.opt.ignorecase = false -- ignore case in search patterns
vim.opt.incsearch = true   -- highlight match while typing search pattern

vim.opt.list = true
vim.opt.listchars = {
	tab = '> ',
	-- eol = '~',
	space = '•',
}

vim.opt.menuitems = 8               -- maximum number of items in a menu

vim.opt.mouse = "nvi"               -- enable the use of mouse clicks
vim.opt.mousefocus = true           -- keyboard focus follows the mouse
vim.opt.mousehide = true            -- hide mouse pointer while typing
vim.opt.mousemodel = "extend"       -- set the model to use for the mouse
vim.opt.mousescroll = "ver:1,hor:2" -- set by how much the mousewheel will scroll

vim.opt.number = true               -- print the line number in front of each line
vim.opt.numberwidth = 4             -- number of columns used for the line number
vim.opt.relativenumber = true       -- show relative line number in front of each line

vim.opt.scrolloff = 8               -- minimum nr. of lines above and below cursor
vim.opt.showmode = false            -- message on status line to show current mode
vim.opt.sidescrolloff = 15          -- min. nr. of columns to left and right of cursor

vim.opt.smartindent = true          -- smart autoindenting for C programs
vim.opt.smarttab = true             -- use 'shiftwidth' when inserting <Tab>
vim.opt.shiftwidth = 4              -- Number of spaces to use for each step of (auto)indent
vim.opt.softtabstop = 0             -- number of spaces that <Tab> uses while editing
vim.opt.tabstop = 4                 -- number of spaces that <Tab> in file uses

vim.opt.wrap = false                -- long lines wrap and continue on the next line

-- :h c.vim
vim.cmd("au BufRead,BufNewFile *.h set filetype=c")
vim.cmd("let g:loaded_python3_provider = 0")
vim.cmd("let g:loaded_ruby_provider = 0")
vim.cmd("let g:loaded_perl_provider = 0")
-- vim.cmd("set list")
