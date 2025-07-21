-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

return {
  "AstroNvim/astrolsp",
  opts = {
    features = {
      codelens = true,
      inlay_hints = false,
      semantic_tokens = true,
    },
    formatting = {
      format_on_save = {
        enabled = true,
        allow_filetypes = {},
        ignore_filetypes = {},
      },
      disabled = {},
      timeout_ms = 1000,
    },
    servers = {},
    config = {
      -- Configuración básica de Angular LSP sin scripts complejos
      angularls = {
        cmd = { "ngserver", "--stdio" },
        root_dir = require("lspconfig.util").root_pattern("angular.json", "project.json"),
        settings = {
          angular = {
            log = "off"
          }
        }
      },
      eslint = {
        root_dir = require("lspconfig.util").root_pattern(
          "package.json",
          ".eslintrc.js",
          ".eslintrc.json",
          "eslint.config.js"
        ),
        settings = {
          packageManager = "npm",
          workingDirectory = { mode = "auto" }
        }
      },
    },
    handlers = {},
    autocmds = {
      lsp_codelens_refresh = {
        cond = "textDocument/codeLens",
        {
          event = { "InsertLeave", "BufEnter" },
          desc = "Refresh codelens (buffer)",
          callback = function(args)
            if require("astrolsp").config.features.codelens then
              vim.lsp.codelens.refresh { bufnr = args.buf }
            end
          end,
        },
      },
    },
    mappings = {
      n = {
        gD = {
          function() vim.lsp.buf.declaration() end,
          desc = "Declaration of current symbol",
          cond = "textDocument/declaration",
        },
        ["<Leader>uY"] = {
          function() require("astrolsp.toggles").buffer_semantic_tokens() end,
          desc = "Toggle LSP semantic highlight (buffer)",
          cond = function(client)
            return client:supports_method("textDocument/semanticTokens/full") and vim.lsp.semantic_tokens ~= nil
          end,
        },
      },
    },
  },
}
