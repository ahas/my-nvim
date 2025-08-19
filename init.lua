vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- Bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- Close LSP Locations window when the file open
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, "n", "<CR>", "<CR>:cclose<CR>", { noremap = true, silent = true })
  end,
})

-- Load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- Load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"
require("mappings").init()

-- Add file types
vim.filetype.add {
  pattern = {
    [".*%.ipynb.*"] = "python",
  },
}

-- Init cwd
local function get_first_arg()
  local arg = vim.fn.argv(0)

  if type(arg) == "table" then return tostring(arg[1] or "") end

  return tostring(arg)
end

local function is_wsl() return vim.loop.os_uname().release:lower():find "wsl" ~= nil end
local function is_wayland() return vim.env.WAYLAND_DISPLAY and vim.env.WAYLAND_DISPLAY ~= "" end

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

local function init_cwd_to(path)
  if path and path ~= "" then
    local root = convert_to_local_path(path)
    vim.print("set nvim-tree root to " .. root)
    vim.cmd("cd " .. root)

    return root
  end

  return nil
end

local function focus_open_file()
  local filename = vim.api.nvim_buf_get_name(1)

  if not filename then return end

  vim.print("focus open file: " .. filename)

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local bufname = vim.api.nvim_buf_get_name(buf)
    if bufname:match(filename) then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local arg0 = get_first_arg()

    if arg0 ~= "" then
      local root = init_cwd_to(arg0)
      focus_open_file()

      vim.cmd "set title"
      vim.cmd("set titlestring=" .. root)

      local project_local = vim.fn.getcwd() .. "/.nvim/init.lua"
      if vim.fn.filereadable(project_local) == 1 then dofile(project_local) end
    end
  end,
})

vim.api.nvim_set_hl(0, "Search", { fg = "white", bg = "red" })

-- Set system clipboard for WSL2
if is_wsl() and is_wayland() then
  vim.g.clipboard = {
    name = "win32yank",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
    cache_enabled = 0,
  }
end
