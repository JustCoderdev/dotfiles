declare_file("keymaps.lua")
-- :lua vim.lsp.buf.signature_help()


local opts = { noremap = true, silent = true }
local function map(modes, keybinding, action)
	for i = 1, string.len(modes) do
		local m = string.sub(modes, i, i)
		vim.keymap.set(m, keybinding, action, opts)
	end
end
local function mapn(keybinding, action) map("n", keybinding, action) end
local function mapi(keybinding, action) map("i", keybinding, action) end
local function mapv(keybinding, action) map("v", keybinding, action) end
local function mapx(keybinding, action) map("x", keybinding, action) end
local function disable(modes, key) map(modes, key, "<Nop>") end


-- Modes --
--	n normal mode
--	i insert mode
--	v visual mode
--	x visual block mode
--	t term mode
--	c command mode


-- === DISABLED === --
disable("n", "Q")
disable("n", "'")
disable("i", "<A-k>")
disable("i", "<A-j>")

-- arrows
disable("nivx", "<Up>")
disable("nivx", "<Down>")
disable("nivx", "<Left>")
disable("nivx", "<Right>")

-- leader
disable("n", "<Space>")


--  === LEADER === --
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- nvim_lspconfig overriden
--   "gD", "gd", "K", "gi", "gr", "<C-k>",
--   "<Leader>d", "<Leader>r", "<Leader>f"

mapn("<Leader>m", ":mksession! session.vim <CR> :echo \"Updated session file\" <CR>")
mapn("<Leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

-- save
mapn("<Leader>u", ":w <CR> :source %<CR> :echo \"Sourced current file\" <CR>")
mapn("<Leader>w", ":wall <CR> :echo \"Saved all files\" <CR>")
mapn("<Leader>q", ":wall <CR> :mksession! last_session.vim <CR> :qall <CR>")

-- plugins
mapn("<Leader>f", ":Neoformat <CR>")			-- from neoformat
mapn("<Leader>sw", ":StripWhitespace <CR>")		-- from vim-better-whitespace

-- clipboard
map("nv", "<Leader>y", "\"+y :echo \"Yanked to system clipboard\" <CR>")
map("nv", "<Leader>p", "\"*p :echo \"Pasted from system clipboard\" <CR>")

-- windows
mapn("<Leader>e", ":Lexplore 25 <CR>")
mapn("<Leader>o", ":SymbolsOutline <CR>")


-- === NORMAL === --
mapn("J", "J0")

-- search
mapn("n", "nzzzv")
mapn("N", "Nzzzv")

-- page jump
mapn("<C-d>", "<C-d>zz")
mapn("<C-u>", "<C-u>zz")

-- navigation
mapn("<C-h>", "<C-w>h")
mapn("<C-j>", "<C-w>j")
mapn("<C-k>", "<C-w>k")
mapn("<C-l>", "<C-w>l")

-- resize
mapn("<C-Up>", ":resize -2 <CR>")
mapn("<C-Down>", ":resize +2 <CR>")
-- mapn("<C-Left>", ":vertical resize -2 <CR>")
-- mapn("<C-Right>", ":vertical resize +2 <CR>")


-- === INSERT === --
mapi("jk", "<Esc>")
mapi("<C-c>", "<Esc>") -- update view after exiting with C-c


-- === VISUAL === --
map("x", "p", "\"_dP")

-- indent
mapv("<", "<gv")
mapv(">", ">gv")

-- move text
-- mapv("J", ":move '>+1 <CR> gv=gv")
-- mapv("K", ":move '<-2 <CR> gv=gv")


-- === VISUAL BLOCK === --
-- move text
-- mapx("J", ":move '>+1 <CR> gv-gv")
-- mapx("K", ":move '<-2 <CR> gv-gv")
