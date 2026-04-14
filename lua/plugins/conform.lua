local prettier_config_files = {
  ".prettierrc",
  ".prettierrc.js",
  ".prettierrc.cjs",
  ".prettierrc.mjs",
  ".prettierrc.json",
  ".prettierrc.json5",
  ".prettierrc.yaml",
  ".prettierrc.yml",
  ".prettierrc.toml",
  "prettier.config.js",
  "prettier.config.cjs",
  "prettier.config.mjs",
  "prettier.config.ts",
}

local function prettier_condition(_, ctx)
  return vim.fs.find(prettier_config_files, {
    upward = true,
    path = ctx.dirname,
  })[1] ~= nil
end

return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      javascript = { "prettierd" },
      javascriptreact = { "prettierd" },
      typescript = { "prettierd" },
      typescriptreact = { "prettierd" },
      html = { "prettierd" },
      htmlangular = { "prettierd" },
      css = { "prettierd" },
      scss = { "prettierd" },
      json = { "prettierd" },
      jsonc = { "prettierd" },
      yaml = { "prettierd" },
      markdown = { "prettierd" },
    },
    formatters = {
      prettierd = { condition = prettier_condition },
    },
    format_on_save = {
      lsp_format = "fallback",
      timeout_ms = 5000,
    },
  },
}
