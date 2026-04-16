---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  version = false, -- always track latest to avoid ABI mismatches after Neovim updates
  opts = {
    -- Install parsers synchronously during startup only when missing
    sync_install = false,
    -- Automatically install missing parsers when opening a buffer
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    ensure_installed = {
      -- Lua / Vim (config files)
      "lua",
      "vim",
      "vimdoc",
      -- Markdown (required by render-markdown.nvim — both are mandatory)
      "markdown",
      "markdown_inline",
      -- Web
      "html",
      "css",
      "javascript",
      "typescript",
      "tsx",
      -- Common
      "json",
      "jsonc",
      "yaml",
      "toml",
      "bash",
      "regex",
    },
  },
}
