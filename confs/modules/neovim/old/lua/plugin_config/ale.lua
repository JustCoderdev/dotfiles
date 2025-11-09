declare_plugin_config("ale")

vim.cmd("let b:ale_fixers = []") -- ['prettier', 'eslint']
vim.cmd("let g:ale_fix_on_save = 0 ")
vim.cmd("let g:ale_completion_enabled = 0")
vim.cmd("let g:ale_completion_autoimport = 0")
vim.cmd("let g:ale_disable_lsp = 1")

-- Linting
-- vim.cmd("let g:ale_linters = { 'c': ['clang', 'astyle', '']}")
vim.cmd("let g:ale_lint_on_text_changed = 1")
vim.cmd("let g:ale_lint_on_insert_leave = 1")
vim.cmd("let g:ale_lint_on_enter = 1")
vim.cmd("let g:ale_lint_on_save = 1")

-- c stuff
vim.cmd("let g:ale_c_cc_options = '-xc -Wall -Wextra -Werror -Wpedantic -pedantic -pedantic-errors -std=c89 -fcolor-diagnostics'")
--flawfinder
--
vim.cmd("let g:ale_c_flawfinder_minlevel = 0")
--clang
vim.cmd("let g:ale_c_build_dir = ''")
vim.cmd("let g:ale_c_build_dir_names = ['build', 'bin']")
vim.cmd("let g:ale_c_clang_executable = 'clang'")
vim.cmd("let g:ale_c_clang_options = '-xc -Wall -Wextra -Werror -Wpedantic -pedantic -pedantic-errors -std=c89 -fcolor-diagnostics'")
vim.cmd("let g:ale_c_parse_compile_commands = 1")
vim.cmd("let g:ale_c_parse_makefile = 1")
