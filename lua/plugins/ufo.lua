
return {
  "kevinhwang91/nvim-ufo",
  event = "BufReadPost",
  dependencies = {
    "kevinhwang91/promise-async",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    provider_selector = function(bufnr, filetype, buftype)
      local ok, parser = pcall(require("nvim-treesitter.parsers").get_parser, bufnr)
      if ok and parser and parser._root then
        return { "treesitter", "indent" }
      else
        return { "indent" }
      end
    end,
  },
}
