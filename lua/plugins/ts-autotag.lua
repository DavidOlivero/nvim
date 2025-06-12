return {
  {
    "windwp/nvim-ts-autotag",
    dependencies = "nvim-treesitter/nvim-treesitter",
    event = "InsertEnter",
    config = function()
      require('nvim-ts-autotag').setup({
        opts = {
          -- Defaults
          enable_close = true, -- Auto close tags
          enable_rename = true, -- Auto rename pairs of tags
          enable_close_on_slash = false -- Auto close on trailing </
        },
        -- También anula las configuraciones individuales de filetype, estas tienen prioridad.
        -- Vacío por defecto, útil si una de las configuraciones globales "opts"
        -- no funciona bien en un filetype específico
        per_filetype = {
          ["html"] = {
            enable_close = false
          }
        }
      })
    end,
  }
}
