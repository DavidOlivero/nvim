return {
  {
    'akinsho/git-conflict.nvim', 
    version = "*",
    opts = {
      -- Desactivar mapeos predeterminados
      default_mappings = false,
    },
    config = function(_, opts)
      require("git-conflict").setup(opts)
      
      -- Definir mapeos personalizados con el prefijo 'fg'
      vim.keymap.set('n', 'fgo', '<Plug>(git-conflict-ours)', { desc = "Git conflict - choose ours" })
      vim.keymap.set('n', 'fgt', '<Plug>(git-conflict-theirs)', { desc = "Git conflict - choose theirs" })
      vim.keymap.set('n', 'fgb', '<Plug>(git-conflict-both)', { desc = "Git conflict - choose both" })
      vim.keymap.set('n', 'fgn', '<Plug>(git-conflict-none)', { desc = "Git conflict - choose none" })
      vim.keymap.set('n', 'fgp', '<Plug>(git-conflict-prev-conflict)', { desc = "Git conflict - previous conflict" })
      vim.keymap.set('n', 'fgj', '<Plug>(git-conflict-next-conflict)', { desc = "Git conflict - next conflict" })
      vim.keymap.set('n', 'fgl', ':GitConflictListQf<CR>', { desc = "Git conflict - list all conflicts" })
      
      -- Crear autocomando para añadir texto virtual encima de cada conflicto
      vim.api.nvim_create_autocmd('User', {
        pattern = 'GitConflictDetected',
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          local ns_id = vim.api.nvim_create_namespace('git_conflict_help')
          
          -- Limpiar los extmarks existentes
          vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
          
          -- Buscar todas las líneas con marcadores de conflicto
          local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
          for i, line in ipairs(lines) do
            if line:match("^<<<<<<< ") then
              -- Crear texto virtual encima de cada conflicto
              vim.api.nvim_buf_set_extmark(bufnr, ns_id, i-1, 0, {
                virt_text_pos = "overlay",
                virt_text = {
                  {"Git Conflict: ", "WarningMsg"},
                  {"[fgo] Ours  ", "Special"},
                  {"[fgt] Theirs  ", "Special"},
                  {"[fgb] Both  ", "Special"},
                  {"[fgn] None", "Special"}
                },
                virt_text_win_col = 0,
              })
            end
          end
          
          -- Actualizar el texto virtual cuando se resuelve un conflicto
          vim.api.nvim_create_autocmd('User', {
            pattern = 'GitConflictResolved',
            callback = function()
              vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
            end,
            once = true
          })
        end
      })
    end
  }
}
