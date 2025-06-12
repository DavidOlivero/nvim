return {
  {
    "giusgad/pets.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "giusgad/hologram.nvim"
    },
    config = function()
      require("pets").setup({
        speed_multiplier = 1,
        default_pet = "dog",
        default_style = "brown",
        random = false,
        death_animation = true,
        popup = {
          avoid_statusline = true,
          win_opts = {
            winblend = 100,     -- 100 = totalmente transparente
            border = "none",    -- sin borde
          }
        }
      })
    end
  }
}
 
