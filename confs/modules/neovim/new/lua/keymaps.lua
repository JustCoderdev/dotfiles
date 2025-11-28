declare_file("keymaps")

-- Modes --
-- [n]ormal [i]nsert [v]isual [t]erm [c]ommand
-- [x] visual block

local function map(modes, keybinding, action)
	for i = 1, string.len(modes) do
		local m = string.sub(modes, i, i)
		local opts = { noremap = true, silent = true }
		vim.keymap.set(m, keybinding, action, opts)
	end
end

local function unmap(modes, keybinding) map(modes, keybinding, "<Nop>") end


-- Disable keys
-- #----------------------------------------------------------# --

unmap("n", "Q")
unmap("n", "'")
unmap("i", "<M-k>")
unmap("i", "<M-j>")
unmap("n", "<Space>")


-- disable mouse selection
unmap("niv", "<RightMouse>")
unmap("niv", "<A-RightMouse>")
unmap("niv", "<S-RightMouse>")
unmap("niv", "<C-RightMouse>")
unmap("niv", "<MiddleMouse>")


-- arrows
unmap("nivx", "<Up>")
unmap("nivx", "<Down>")
unmap("nivx", "<Left>")
unmap("nivx", "<Right>")

unmap("nivx", "<S-Up>")
unmap("nivx", "<S-Down>")
unmap("nivx", "<S-Left>")
unmap("nivx", "<S-Right>")

unmap("nivx", "<C-Up>")
unmap("nivx", "<C-Down>")
unmap("nivx", "<C-Left>")
unmap("nivx", "<C-Right>")

unmap("nivx", "<C-S-Up>")
unmap("nivx", "<C-S-Down>")
unmap("nivx", "<C-S-Left>")
unmap("nivx", "<C-S-Right>")


-- Set leader key
-- #----------------------------------------------------------# --

vim.g.mapleader = " "
vim.g.maplocalleader = vim.g.mapleader

-- save
map("n", "<Leader>ww", string.format(":wall <CR> :mksession! %s/.old_session.vim <CR> :echo \"Saved all files\" <CR>", vim.fn.getcwd()))
map("n", "<Leader>qq", string.format(":wall <CR> :mksession! %s/.old_session.vim <CR> :qall <CR>", vim.fn.getcwd()))
map("n", "<Leader>s",  ":w <CR> :source %<CR> :echo \"Sourced current file\" <CR>")

map("vx", "<Leader>ww", "<ESC>:wall <CR> :echo \"Saved all files\" <CR>")
map("vx", "<Leader>qq", "<ESC>:wall <CR> :mksession! .old_session.vim <CR> :qall <CR>")
map("vx", "<Leader>s",  "<ESC>:w <CR> :source %<CR> :echo \"Sourced current file\" <CR>")


-- plugins
-- map("a", "<Leader>s", ":StripWhitespace <CR>")          -- from vim-better-whitespace
-- map("a", "<Leader>h", ":FzfLua files resume=true <CR>")  -- from fzf
-- map("a", "<Leader>H", ":FzfLua files <CR>")              -- from fzf
-- map("a", "<Leader>g", ":FzfLua grep resume=true <CR>")  -- from fzf
-- map("a", "<Leader>G", ":FzfLua grep <CR>")              -- from fzf
-- map("a", "<Leader>d", ":FzfLua git_status resume=true <CR>")  -- from fzf
-- map("a", "<Leader>D", ":FzfLua git_status <CR>")              -- from fzf


-- clipboard
map("n", "<Leader>yy", "\"+yy :echo \"Yanked to system clipboard\" <CR>")
map("vx", "<Leader>y", "\"+y  :echo \"Yanked to system clipboard\" <CR>")
map("n",  "<Leader>p", "\"+p  :echo \"Pasted from system clipboard\" <CR>")

-- windows
-- map("n", "<Leader>c", ":lopen <CR>")
map("n", "<Leader>e", ":Lexplore 20 <CR>")
map("v", "<Leader>e", "<ESC>:Lexplore 20 <CR>")

map("n", "<Leader>f",  ":Ex <CR>")
map("v", "<Leader>f",  "<ESC> :Ex <CR>")


-- Set normal keybindings
-- #----------------------------------------------------------# --

map("n", "J", "J0")
map("n", "<C-w>q", ":q <CR>")

-- page jump
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<M-d>", "<C-d>zz")
map("n", "<M-u>", "<C-u>zz")

-- navigation
map("n", "<M-h>", "<C-w>h")
map("n", "<M-j>", "<C-w>j")
map("n", "<M-k>", "<C-w>k")
map("n", "<M-l>", "<C-w>l")
map("n", "<M-q>", ":q <CR>")

-- resize
map("n", "<C-k>", ":resize -2 <CR>")
map("n", "<C-j>", ":resize +2 <CR>")
map("n", "<C-h>", ":vertical resize -2 <CR>")
map("n", "<C-l>", ":vertical resize +2 <CR>")


-- #------------------# --

map("t", "<ESC>", "<C-\\><C-n>")

-- move buffer
map("t", "<M-h>", "<C-\\><C-N> <C-w>h")
map("t", "<M-j>", "<C-\\><C-N> <C-w>j")
map("t", "<M-k>", "<C-\\><C-N> <C-w>k")
map("t", "<M-l>", "<C-\\><C-N> <C-w>l")


-- #------------------# --

map("x", "p", "\"_dP")
map("nvx", "/", "<ESC>:noh<CR>:echo\"/\"<CR>/")

-- indent
map("vx", "<", "<gv")
map("vx", ">", ">gv")


-- Plugin diagnostics
-- #----------------------------------------------------------# --

--These diagnostic keymaps are created unconditionally when Nvim starts:
--     `]d` jumps to the next diagnostic in the buffer
--     `[d` jumps to the previous diagnostic in the buffer
--     `]D` jumps to the last diagnostic in the buffer
--     `[D` jumps to the first diagnostic in the buffer
-- `<C-w>d` shows diagnostic at cursor in a floating window

