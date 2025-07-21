return {
  {
    'akinsho/git-conflict.nvim', 
    version = "*",
    opts = {
      default_mappings = false,
    },
    config = function(_, opts)
      require("git-conflict").setup(opts)
      vim.keymap.set('n', 'fgo', '<Plug>(git-conflict-ours)', { desc = "Git conflict - choose ours" })
      vim.keymap.set('n', 'fgt', '<Plug>(git-conflict-theirs)', { desc = "Git conflict - choose theirs" })
      vim.keymap.set('n', 'fgb', '<Plug>(git-conflict-both)', { desc = "Git conflict - choose both" })
      vim.keymap.set('n', 'fgn', '<Plug>(git-conflict-none)', { desc = "Git conflict - choose none" })
      vim.keymap.set('n', 'fgp', '<Plug>(git-conflict-prev-conflict)', { desc = "Git conflict - previous conflict" })
      vim.keymap.set('n', 'fgj', '<Plug>(git-conflict-next-conflict)', { desc = "Git conflict - next conflict" })
      vim.keymap.set('n', 'fgl', ':GitConflictListQf<CR>', { desc = "Git conflict - list all conflicts" })
      vim.api.nvim_create_autocmd('User', {
        pattern = 'GitConflictDetected',
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          local ns_id = vim.api.nvim_create_namespace('git_conflict_help')
          vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
          vim.notify("Git conflicts detected! Use fgo/fgt/fgb/fgn to resolve", vim.log.levels.WARN)
        end
      })
    end
  }
}
