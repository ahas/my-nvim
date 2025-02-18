require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- window resize
map("n", "<C-Up>", "1<C-w>-", { noremap = true, silent = true, desc = "Decrease height" })
map("n", "<C-Down>", "1<C-w>+", { noremap = true, silent = true, desc = "Increase height" })
map("n", "<C-Left>", "1<C-w>>", { noremap = true, silent = true, desc = "Decrease width" })
map("n", "<C-Right>", "1<C-w><", { noremap = true, silent = true, desc = "Increase width" })

-- buffers
map("n", "[b", "<Cmd>bprev<CR>", { noremap = true, silent = true })
map("n", "]b", "<Cmd>bnext<CR>", { noremap = true, silent = true })

-- dap
local dap = require "dap"
local dapui = require "dapui"

map("n", "<F5>", function()
  dap.continue()
end, { desc = "Start Debugging" })
map("n", "<F10>", function()
  dap.step_over()
end, { desc = "Step Over" })
map("n", "<F11>", function()
  dap.step_into()
end, { desc = "Step Into" })
map("n", "<F12>", function()
  dap.step_out()
end, { desc = "Step Out" })
map("n", "<F9>", function()
  dap.toggle_breakpoint()
end, { desc = "Toggle Breakpoint" })
map("n", "<Leader>du", function()
  dapui.toggle()
end, { desc = "Toggle DAP UI" })

vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapBreakpointCondition", { text = "🔵", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapLogPoint", { text = "📍", texthl = "Todo", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "➡️", texthl = "Title", linehl = "CursorLine", numhl = "" })
vim.fn.sign_define("DapBreakpointRejected", { text = "❌", texthl = "ErrorMsg", linehl = "", numhl = "" })
