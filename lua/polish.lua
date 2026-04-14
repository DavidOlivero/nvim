-- This will run last in the setup process and is just pure Lua.

-- Spelling
vim.opt.spell = true
vim.opt.spelllang = { "en_us", "es" }
vim.opt.spelloptions = "camel"

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function() vim.opt_local.spell = false end,
})
