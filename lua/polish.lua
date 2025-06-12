--if true then return end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- This will run last in the setup process.
-- This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Habilitar transparencia de fondo
vim.api.nvim_command("hi Normal guibg=NONE ctermbg=NONE")
vim.api.nvim_command("hi NormalNC guibg=NONE ctermbg=NONE")
vim.api.nvim_command("hi NormalFloat guibg=NONE ctermbg=NONE")
vim.api.nvim_command("hi FloatBorder guibg=NONE ctermbg=NONE")
vim.api.nvim_command("hi SignColumn guibg=NONE ctermbg=NONE")
vim.api.nvim_command("hi LineNr guibg=#2a2a37")
vim.opt.numberwidth = 6
vim.api.nvim_command("hi SignColumn guibg=NONE ctermbg=NONE")

-- Menús y elementos flotantes
vim.api.nvim_command("hi Pmenu guibg=NONE ctermbg=NONE")
vim.api.nvim_command("hi PmenuSbar guibg=NONE ctermbg=NONE")
vim.api.nvim_command("hi PmenuThumb guibg=NONE ctermbg=NONE")

-- Barras de estado, pestañas, etc.
-- vim.api.nvim_command("hi StatusLine guibg=NONE ctermbg=NONE")
-- vim.api.nvim_command("hi StatusLineNC guibg=NONE ctermbg=NONE")
-- vim.api.nvim_command("hi TabLine guibg=NONE ctermbg=NONE")
-- vim.api.nvim_command("hi TabLineFill guibg=NONE ctermbg=NONE")
-- vim.api.nvim_command("hi TabLineSel guibg=NONE ctermbg=NONE")

-- Signos de git
vim.api.nvim_command("hi GitSignsAdd guibg=NONE")
vim.api.nvim_command("hi GitSignsChange guibg=NONE")
vim.api.nvim_command("hi GitSignsDelete guibg=NONE")

-- Para asegurar que persista incluso después de cambiar de modo
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_command("hi Normal guibg=NONE ctermbg=NONE")
    vim.api.nvim_command("hi NormalNC guibg=NONE ctermbg=NONE")
    vim.api.nvim_command("hi NormalFloat guibg=NONE ctermbg=NONE")
    vim.api.nvim_command("hi FloatBorder guibg=NONE ctermbg=NONE")
  end,
})
