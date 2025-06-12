return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      javascript = { "prettierd", "prettier" },
      typescript = { "prettierd", "prettier" },
      html = { "prettierd", "prettier" },
      htmlangular = { "prettierd", "prettier" },
      css = { "prettierd", "prettier" },
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
      timeout_ms = 500,
    },
  },
}
