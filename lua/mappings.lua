require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- window resize
map("n", "<C-Up>", "1<C-w>-", { noremap = true, silent = true, desc = "Window Decrease height" })
map("n", "<C-Down>", "1<C-w>+", { noremap = true, silent = true, desc = "Window Increase height" })
map("n", "<C-Left>", "1<C-w>>", { noremap = true, silent = true, desc = "Window Decrease width" })
map("n", "<C-Right>", "1<C-w><", { noremap = true, silent = true, desc = "Window Increase width" })

-- buffers
map("n", "[b", "<Cmd>bprev<CR>", { noremap = true, silent = true, desc = "Buffer Goto Previous" })
map("n", "]b", "<Cmd>bnext<CR>", { noremap = true, silent = true, desc = "Buffer Goto Next" })

-- dap
local dap = require "dap"
local dapui = require "dapui"

map("n", "<F5>", function()
  dap.continue()
end, { desc = "Debugger Start / Continue" })
map("n", "<F10>", function()
  dap.step_over()
end, { desc = "Debugger Step Over" })
map("n", "<F11>", function()
  dap.step_into()
end, { desc = "Debugger Step Into" })
map("n", "<F12>", function()
  dap.step_out()
end, { desc = "Debugger Step Out" })
map("n", "<F9>", function()
  dap.toggle_breakpoint()
end, { desc = "Debugger Toggle Breakpoint" })
map("n", "<Leader>du", function()
  dapui.toggle()
end, { desc = "Toggle DAP UI" })

vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "🔵", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "📍", texthl = "Todo", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "➡️", texthl = "Title", linehl = "CursorLine", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "❌", texthl = "ErrorMsg", linehl = "", numhl = "" })

-- neovide
if vim.g.neovide then
  map(
    { "n", "v" },
    "<C-+>",
    ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>",
    { noremap = true, silent = true, desc = "Neovide Increase scale factor" }
  )
  map(
    { "n", "v" },
    "<C-_>",
    ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>",
    { noremap = true, silent = true, desc = "Neovide Decrease scale factor" }
  )
  map(
    { "n", "v" },
    "<C-0>",
    ":lua vim.g.neovide_scale_factor = 1<CR>",
    { noremap = true, silent = true, desc = "Neovide Reset scale factor" }
  )
  map(
    "n",
    "<F11>",
    ":lua vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen<CR>",
    { noremap = true, silent = true, desc = "Neovide Fullscreen" }
  )
end
