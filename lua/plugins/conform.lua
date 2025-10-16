return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      javascript = { "prettierd", "prettierd" },
      typescript = { "prettierd", "prettierd" },
      html = { "prettierd", "prettierd" },
      htmlangular = { "prettierd", "prettierd" },
      css = { "prettierd", "prettierd" },
    },
    formatters = {
      prettierd = {
        condition = function(ctx)
          return vim.fs.find({
            ".prettierrc",
            ".prettierrc.js",
            "prettier.config.js",
            "prettier.config.cjs",
            ".prettierrc.json",
          }, {
            upward = true,
            path = ctx.filename,
          })[1]
        end,
      },
      prettier = {
        condition = function(ctx)
          return vim.fs.find({
            ".prettierrc",
            ".prettierrc.js",
            "prettier.config.js",
            "prettier.config.cjs",
            ".prettierrc.json",
          }, {
            upward = true,
            path = ctx.filename,
          })[1]
        end,
      },
    },
    format_on_save = {
      lsp_fallback = true,
      timeout_ms = 5000,
    },
  },
}
