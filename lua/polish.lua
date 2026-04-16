-- This will run last in the setup process and is just pure Lua.

-- ── Dashboard animation ───────────────────────────────────────────────────
-- Story: typing on laptop → looks up → ¯\_(ツ)_/¯ with bounce.
-- Uses the blank line above the shrug as a second canvas line.
vim.api.nvim_create_autocmd("User", {
  pattern = "SnacksDashboardOpened",
  once = true,
  callback = function()
    local buf      = vim.api.nvim_get_current_buf()
    local all_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

    -- Find the shrug line (0-based index)
    local lnum = nil
    for i, line in ipairs(all_lines) do
      if line:match("%(ツ%)") then lnum = i - 1; break end
    end
    if not lnum or lnum < 1 then return end

    -- The blank line immediately above the shrug is our second canvas row
    local top_lnum   = lnum - 1
    local has_top    = all_lines[top_lnum + 1]:match("^%s*$") ~= nil
    local start_lnum = has_top and top_lnum or lnum
    local n_lines    = has_top and 2 or 1

    -- Preserve the indent snacks applied so frames stay centred
    local indent = all_lines[lnum + 1]:match("^(%s*)") or ""

    local function frame(top, bot)
      if has_top then
        return { indent .. top, indent .. bot }
      end
      return { indent .. bot }
    end

    -- {delay_ms, top_line, bot_line}
    local seq = {
      { 150,  "  o(-_-)o   ", "  [======]  " }, -- focused on laptop
      { 380,  "  o(-.-)o   ", "  [======]  " }, -- blink while typing
      { 610,  "  o(-_-)o   ", "  [======]  " }, -- still typing
      { 840,  "  o(-_-)o   ", "  [======]  " }, -- ...
      { 1020, "   (O_O)    ", "    |||     " }, -- looks up surprised
      { 1250, "   (ツ)     ", "    \\|/    " }, -- sees the situation, relaxes
      { 1500, "            ", "  \\(ツ)/   " }, -- arms start lifting
      { 1750, "            ", "¯\\_(ツ)_/¯ " }, -- full shrug
      { 2000, "            ", "  \\(ツ)/   " }, -- bounce
      { 2180, "            ", "¯\\_(ツ)_/¯ " }, -- settle
    }

    for _, step in ipairs(seq) do
      local delay, top, bot = step[1], step[2], step[3]
      vim.defer_fn(function()
        if not vim.api.nvim_buf_is_valid(buf) then return end
        local was_mod = vim.bo[buf].modifiable
        vim.bo[buf].modifiable = true
        vim.api.nvim_buf_set_lines(buf, start_lnum, start_lnum + n_lines, false, frame(top, bot))
        vim.bo[buf].modifiable = was_mod
      end, delay)
    end
  end,
})
-- ──────────────────────────────────────────────────────────────────────────

-- Spelling
vim.opt.spell = true
vim.opt.spelllang = { "en_us", "es" }
vim.opt.spelloptions = "camel"

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function() vim.opt_local.spell = false end,
})
