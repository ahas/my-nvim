local M = {}

function M.is_wsl() return vim.loop.os_uname().release:lower():find "wsl" ~= nil end

function M.is_wayland() return vim.env.WAYLAND_DISPLAY and vim.env.WAYLAND_DISPLAY ~= "" end

function M.is_vscode() return vim.g.vscode end

function M.is_windows()
  local uv = vim.uv or vim.loop
  return uv.os_uname().sysname:match "Windows" ~= nil
end

return M
