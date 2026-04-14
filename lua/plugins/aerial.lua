return {
  "stevearc/aerial.nvim",
  -- Use opts as a function so it fully replaces AstroNvim defaults
  -- instead of being merged/appended.
  opts = function(_, opts)
    -- aerial.nvim's treesitter backend is incompatible with newer
    -- nvim-treesitter versions (calls a 'start' method that no longer exists).
    -- Removing treesitter from backends fixes the startup error.
    opts.backends = { "lsp", "markdown", "asciidoc", "man" }
  end,
}
