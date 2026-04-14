
return {
  "kevinhwang91/nvim-ufo",
  event = "BufReadPost",
  dependencies = {
    "kevinhwang91/promise-async",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    provider_selector = function(bufnr, filetype, buftype)
      local ok, parser = pcall(require("nvim-treesitter.parsers").get_parser, bufnr, filetype)
      if ok and parser then
        return { "treesitter", "indent" }
      end
      return { "indent" }
    end,
  },
}
