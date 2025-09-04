local M = {}

function M.is_wsl() return vim.loop.os_uname().release:lower():find "wsl" ~= nil end

function M.is_wayland() return vim.env.WAYLAND_DISPLAY and vim.env.WAYLAND_DISPLAY ~= "" end

function M.is_vscode() return vim.g.vscode end

return M
