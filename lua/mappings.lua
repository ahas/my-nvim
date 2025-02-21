require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local del = vim.keymap.del

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- window resize
map("n", "<C-Up>", "1<C-w>-", { noremap = true, silent = true, desc = "Window Decrease height" })
map("n", "<C-Down>", "1<C-w>+", { noremap = true, silent = true, desc = "Window Increase height" })
map("n", "<C-Left>", "1<C-w>>", { noremap = true, silent = true, desc = "Window Decrease width" })
map("n", "<C-Right>", "1<C-w><", { noremap = true, silent = true, desc = "Window Increase width" })

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

-- tabufline
del("n", "<leader>b")
del("n", "<tab>")
del("n", "<S-tab>")

map("n", "<leader>bn", "<cmd>enew<CR>", { noremap = true, silent = true, desc = "Buffer New" })
map("n", "[b", function()
  require("nvchad.tabufline").prev()
end, { noremap = true, silent = true, desc = "Buffer Goto Previous" })
map("n", "]b", function()
  require("nvchad.tabufline").next()
end, { noremap = true, silent = true, desc = "Buffer Goto Next" })
map("n", "<leader>bc", function()
  require("nvchad.tabufline").closeAllBufs(false)
end, { noremap = true, silent = true, desc = "Buffer Close others" })
map("n", "<leader>bC", function()
  require("nvchad.tabufline").closeAllBufs(true)
end, { noremap = true, silent = true, desc = "Buffer Close all" })
map("n", "<leader>bl", function()
  require("nvchad.tabufline").closeBufs_at_direction "right"
end, { noremap = true, silent = true, desc = "Buffer Close to the right" })
map("n", "<leader>bh", function()
  require("nvchad.tabufline").closeBufs_at_direction "left"
end, { noremap = true, silent = true, desc = "Buffer Close to the left" })
map("n", "<C-{>", function()
  require("nvchad.tabufline").move_buf(-1)
end, { noremap = true, silent = true, desc = "Buffer move to left" })
map("n", "<C-}>", function()
  require("nvchad.tabufline").move_buf(1)
end, { noremap = true, silent = true, desc = "Buffer move to right" })

-- vim-illuminate
map("x", "<C-i>", require("illuminate").textobj_select)

-- formatting
map("n", "<leader>fo", "<Cmd>OrganizeImports<CR>", { noremap = true, silent = true, desc = "LSP Organize imports" })
