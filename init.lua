vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

-- init nvim tree
local function get_first_arg()
  local arg = vim.fn.argv(0)

  if type(arg) == "table" then
    return tostring(arg[1] or "")
  end

  return tostring(arg)
end

local function is_wsl()
  return vim.loop.os_uname().release:lower():find "wsl" ~= nil
end

local function convert_to_local_path(path)
  if is_wsl() then
    local wsl_distro_name = os.getenv "WSL_DISTRO_NAME"
    local unc_prefix = "\\?\\UNC\\wsl.localhost\\" .. wsl_distro_name

    if path:sub(1, #unc_prefix) == unc_prefix then
      local local_path = path:sub(#unc_prefix + 1):gsub("\\", "/")

      return local_path
    end
  end

  return vim.fn.fnamemodify(path, ":p:h")
end

local function nvim_tree_init()
  local api = require "nvim-tree.api"
  local first_arg = get_first_arg()

  api.tree.open()

  if first_arg and first_arg ~= "" then
    local root = convert_to_local_path(first_arg)
    vim.print("set nvim-tree root to " .. root)
    api.tree.change_root(root)
  end
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = nvim_tree_init,
})
