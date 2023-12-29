declare_file("keymaps.lua")
-- :lua vim.lsp.buf.signature_help()


local opts = { noremap = true, silent = true }
local function map(modes, keybinding, action)
	for i = 1, string.len(modes) do
		local m = string.sub(modes, i, i)
		vim.keymap.set(m, keybinding, action, opts)
	end
end

local function unmap(modes, keybinding)
	map(modes, keybinding, "<Nop>")

	-- for i = 1, string.len(modes) do
	-- 	local m = string.sub(modes, i, i)
	-- 	local all_mode_keymap = vim.api.nvim_get_keymap(m)

	-- 	for _, value in ipairs(all_mode_keymap) do
	-- 		if string.find(value.lhs, keybinding, 0, true) then
	-- 			print(string.format("Unmapping %s from %s", keybinding, m))
	-- 			local successfully_unmapped, error = pcall(vim.keymap.del, m, keybinding)
	-- 			if not successfully_unmapped then

	-- 				vim.keymap.set(m, keybinding, "<Nop>", opts)
	-- 				print(error)
	-- 			end
	-- 		end
	-- 	end
	-- end
end

local function mapn(keybinding, action) map("n", keybinding, action) end
local function mapi(keybinding, action) map("i", keybinding, action) end
local function mapv(keybinding, action) map("v", keybinding, action) end
local function mapx(keybinding, action) map("x", keybinding, action) end

-- Modes --
--	n normal mode
--	i insert mode
--	v visual mode
--	x visual block mode
--	t term mode
--	c command mode


-- === DISABLED === --
unmap("n", "Q")
unmap("n", "'")
unmap("i", "<A-k>")
unmap("i", "<A-j>")

-- arrows
unmap("nivx", "<Up>")
unmap("nivx", "<Down>")
unmap("nivx", "<Left>")
unmap("nivx", "<Right>")

unmap("nivx", "<S-Up>")
unmap("nivx", "<S-Down>")
unmap("nivx", "<S-Left>")
unmap("nivx", "<S-Right>")

-- leader
unmap("n", "<Space>")


--  === LEADER === --
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- nvim_lspconfig overriden
--   "gn", "gN", "gD", "gd", "K", "gi", "gr", "<C-k>",
--   "<Leader>d", "<Leader>rd", "<Leader>ff"

mapn("<Leader>m" , ":mksession! session.vim <CR> :echo \"Updated session file\" <CR>")
mapn("<Leader>rc", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

-- save
mapn("<Leader>u" , ":w <CR> :source %<CR> :echo \"Sourced current file\" <CR>")
mapn("<Leader>ww", ":wall <CR> :echo \"Saved all files\" <CR>")
mapn("<Leader>qq" , ":wall <CR> :mksession! last_session.vim <CR> :qall <CR>")

-- plugins
mapn("<Leader>s", ":StripWhitespace <CR>") -- from vim-better-whitespace
mapn("<Leader>h", ":FzfLua files resume=true <CR>")    -- from fzf

-- clipboard
map("nv", "<Leader>y", "\"+y :echo \"Yanked to system clipboard\" <CR>")
map("nv", "<Leader>p", "\"*p :echo \"Pasted from system clipboard\" <CR>")

-- windows
mapn("<Leader>e", ":Lexplore 25 <CR>")
mapn("<Leader>o", ":SymbolsOutline <CR>")


-- === NORMAL === --
mapn("J", "J0")
mapn("<C-w>h", "<C-w>s")
mapn("<C-w>q", ":q <CR>")

-- search
-- mapn("n", "nzzzv")
-- mapn("N", "Nzzzv")

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
mapn("<C-S-Left>", ":vertical resize -2 <CR>")
mapn("<C-S-Right>", ":vertical resize +2 <CR>")


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
