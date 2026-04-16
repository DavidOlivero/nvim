-- This file simply bootstraps the installation of Lazy.nvim and then calls other files for execution
-- This file doesn't necessarily need to be touched, BE CAUTIOUS editing this file and proceed at your own risk.
local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- validate that lazy is available
if not pcall(require, "lazy") then
  -- stylua: ignore
  vim.api.nvim_echo({ { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } }, true, {})
  vim.fn.getchar()
  vim.cmd.quit()
end

vim.env.PATH = '/usr/bin:' .. vim.env.PATH

-- ── Treesitter ABI guard (must run BEFORE plugins load) ───────────────────
-- The crash "attempt to call method 'range' (a nil value)" happens because
-- some installed treesitter parsers have an ABI mismatch with the current
-- Neovim version. The parser creates a Lua userdata node that passes
-- `if not node` checks (it is truthy) but its metatable is broken —
-- the :range() method does not exist on it.
-- Patching vim.treesitter.get_range with pcall wraps the crash point.
-- This must live here, before require("lazy_setup"), because
-- query_predicates.lua captures `vim.treesitter.get_node_text` at load time.
local _orig_get_range = vim.treesitter.get_range
vim.treesitter.get_range = function(node, source, metadata)
  if node == nil then return { 0, 0, 0, 0, 0, 0 } end
  local ok, result = pcall(_orig_get_range, node, source, metadata)
  if not ok then return { 0, 0, 0, 0, 0, 0 } end
  return result
end

local _orig_get_node_text = vim.treesitter.get_node_text
vim.treesitter.get_node_text = function(node, source, opts)
  if node == nil then return "" end
  local ok, result = pcall(_orig_get_node_text, node, source, opts)
  if not ok then return "" end
  return result
end
-- ─────────────────────────────────────────────────────────────────────────

require "lazy_setup"
require "polish"
