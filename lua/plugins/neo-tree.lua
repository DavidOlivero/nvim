-- Neo-tree customization:
--   · Directories → folder-shape glyph + custom icon (like VS Code Material Icon Theme)
--   · Files       → single file-type icon (no shape, just the icon)
return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = function(_, opts)
    local highlights = require "neo-tree.ui.highlights"

    -- Folder shape glyphs (the "shell", always shown for directories)
    opts.default_component_configs = vim.tbl_deep_extend("force", opts.default_component_configs or {}, {
      icon = {
        folder_closed     = "󰉋",
        folder_open       = "󰝰",
        folder_empty      = "󰉖",
        folder_empty_open = "󰷏",
        default           = "󰈔",
      },
    })

    opts.components = opts.components or {}

    ---@param config table
    ---@param node  table  Neo-tree node
    opts.components.icon = function(config, node, _state)
      -- ── Directories ───────────────────────────────────────────────────
      if node.type == "directory" then
        local expanded = node:is_expanded()
        local empty    = node:get_depth() > 0 and #node:get_children_ids() == 0

        local folder_shape
        if empty then
          folder_shape = expanded and (config.folder_empty_open or "󰷏")
                                  or  (config.folder_empty     or "󰉖")
        else
          folder_shape = expanded and (config.folder_open   or "󰝰")
                                  or  (config.folder_closed or "󰉋")
        end

        -- Ask mini.icons for a custom icon; is_default = true means no mapping.
        local ok, mini = pcall(require, "mini.icons")
        if ok then
          local custom_glyph, _, is_default = mini.get("directory", node.name)
          if not is_default then
            -- folder-shape + custom icon, no space between them so they read as one unit
            return {
              text      = folder_shape .. custom_glyph .. " ",
              highlight = highlights.DIRECTORY_ICON,
            }
          end
        end

        return { text = folder_shape .. " ", highlight = highlights.DIRECTORY_ICON }

      -- ── Files ─────────────────────────────────────────────────────────
      elseif node.type == "file" or node.type == "terminal" then
        local ok, mini = pcall(require, "mini.icons")
        if ok then
          local glyph, hl = mini.get("file", node.name)
          return { text = glyph .. " ", highlight = hl }
        end
      end

      -- ── Fallback ──────────────────────────────────────────────────────
      return {
        text      = (config.default or "󰈔") .. " ",
        highlight = config.highlight or highlights.FILE_ICON,
      }
    end
  end,
}
