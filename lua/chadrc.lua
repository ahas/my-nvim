-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "catppuccin",
  hl_override = {
    ["@comment"] = { fg = "cyan", italic = true },
  },
}

M.ui = {
  statusline = {
    theme = "minimal",
    separator_style = "block",
  },
}

M.disabled = {
  n = {
    ["<tab>"] = "",
  },
}

return M
