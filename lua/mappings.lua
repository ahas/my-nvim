require "nvchad.mappings"

local _with_desc = function(opts, desc) return vim.tbl_extend("force", opts, { desc = desc }) end
local map = vim.keymap.set
local del = vim.keymap.del

function InitMappings()
  map("n", ";", ":", { desc = "CMD enter command mode" })
  map("i", "jk", "<ESC>")
  del("n", "<leader>n")

  -- window resize
  local function init_window_resize()
    local opts = { noremap = true, silent = true }
    local function D(desc) _with_desc(opts, "Window " .. desc) end

    map("n", "<C-Up>", "1<C-w>-", D "Decrease height")
    map("n", "<C-Down>", "1<C-w>+", D "Increase height")
    map("n", "<C-Left>", "1<C-w>>", D "Decrease width")
    map("n", "<C-Right>", "1<C-w><", D "Increase width")
  end

  -- dap
  local function init_dap()
    local dap = require "dap"
    local dapui = require "dapui"
    local opts = { noremap = true, silent = true }
    local function D(desc) return _with_desc(opts, "Debugger " .. desc) end

    map("n", "<F5>", function() dap.continue() end, D "Start / Continue")
    map("n", "<F10>", function() dap.step_over() end, D "Step Over")
    map("n", "<F11>", function() dap.step_into() end, D "Step Into")
    map("n", "<F12>", function() dap.step_out() end, D "Step Out")
    map("n", "<F9>", function() dap.toggle_breakpoint() end, D "Toggle Breakpoint")
    map("n", "<Leader>du", function() dapui.toggle() end, D "Toggle DAP UI")

    vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "🔵", texthl = "", linehl = "", numhl = "" })
    vim.fn.sign_define("DapLogPoint", { text = "📍", texthl = "Todo", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "➡️", texthl = "Title", linehl = "CursorLine", numhl = "" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "❌", texthl = "ErrorMsg", linehl = "", numhl = "" })
  end

  -- neovide
  local function init_neovide()
    if not vim.g.neovide then return end

    local opts = { noremap = true, silent = true }
    local function D(desc) return _with_desc(opts, "Neovide " .. desc) end

    map(
      { "n", "v" },
      "<C-+>",
      ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>",
      D "Increase scale factor"
    )
    map(
      { "n", "v" },
      "<C-_>",
      ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>",
      D "Decrease scale factor"
    )
    map({ "n", "v" }, "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>", D "Reset scale factor")
    map("n", "<F11>", ":lua vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen<CR>", D "Fullscreen")
  end

  -- tabufline
  local function init_tabufline()
    local tabufline = require "nvchad.tabufline"
    local opts = { noremap = true, silent = true }
    local function D(desc) return _with_desc(opts, "Buffer " .. desc) end

    del("n", "<leader>b")
    del("n", "<tab>")
    del("n", "<S-tab>")

    map("n", "<leader>bn", "<cmd>enew<CR>", D "New")
    map("n", "[b", function() tabufline.prev() end, D "Goto Previous")
    map("n", "]b", function() tabufline.next() end, D "Goto Next")
    map("n", "<leader>bc", function() tabufline.closeAllBufs(false) end, D "Close others")
    map("n", "<leader>bC", function() tabufline.closeAllBufs(true) end, D "Close all")
    map("n", "<leader>bl", function() tabufline.closeBufs_at_direction "right" end, D "Close to the right")
    map("n", "<leader>bh", function() tabufline.closeBufs_at_direction "left" end, D "Close to the left")
    map("n", "<C-S-Left>", function() tabufline.move_buf(-1) end, D "Move to left")
    map("n", "<C-S-Right>", function() tabufline.move_buf(1) end, D "Move to right")
  end

  -- telescope
  local function init_telescope()
    local telescope = require "telescope.builtin"
    local opts = { noremap = true, silent = true }
    local function D(desc) return _with_desc(opts, "telescope " .. desc) end

    map("n", "<leader>fW", function()
      telescope.live_grep {
        additional_args = function() return { "--case-sensitive" } end,
      }
    end, D "live grep (case sensitive)")
  end

  -- vim-illuminate
  map("x", "<C-i>", require("illuminate").textobj_select)

  -- formatting
  map("n", "<leader>fo", "<Cmd>OrganizeImports<CR>", { noremap = true, silent = true, desc = "LSP Organize imports" })

  -- crates.nvim
  local function init_crates_nvim()
    local crates = require "crates"
    local opts = { silent = true }
    local function D(desc) return _with_desc(opts, "Crates " .. desc) end

    vim.keymap.set("n", "<leader>ct", crates.toggle, D "Toggle")
    vim.keymap.set("n", "<leader>cr", crates.reload, D "Reload")

    vim.keymap.set("n", "<leader>cv", crates.show_versions_popup, D "Show versions popup")
    vim.keymap.set("n", "<leader>cf", crates.show_features_popup, D "Show features popup")
    vim.keymap.set("n", "<leader>cd", crates.show_dependencies_popup, D "Show dependencies popup")

    vim.keymap.set("n", "<leader>cu", crates.update_crate, D "Update crate")
    vim.keymap.set("v", "<leader>cu", crates.update_crates, D "Update crates")
    vim.keymap.set("n", "<leader>ca", crates.update_all_crates, D "Update all crates")
    vim.keymap.set("n", "<leader>cU", crates.upgrade_crate, D "Upgrade crate")
    vim.keymap.set("v", "<leader>cU", crates.upgrade_crates, D "Upgrade crates")
    vim.keymap.set("n", "<leader>cA", crates.upgrade_all_crates, D "Upgrade all crates")

    vim.keymap.set("n", "<leader>cx", crates.expand_plain_crate_to_inline_table, D "Expand plain crate to inline table")
    vim.keymap.set("n", "<leader>cX", crates.extract_crate_into_table, opts)

    vim.keymap.set("n", "<leader>cH", crates.open_homepage, D "Open homepage")
    vim.keymap.set("n", "<leader>cR", crates.open_repository, D "Open repository")
    vim.keymap.set("n", "<leader>cD", crates.open_documentation, D "Open documentation")
    vim.keymap.set("n", "<leader>cC", crates.open_crates_io, D "Open crates.io")
    vim.keymap.set("n", "<leader>cL", crates.open_lib_rs, D "Open lib.rs")
  end

  -- package-info.nvim
  local function init_package_info_nvim()
    local api = require "package-info"
    local opts = { silent = true, noremap = true }
    local function D(desc) return _with_desc(opts, "PackageInfo " .. desc) end

    vim.keymap.set({ "n" }, "<leader>ns", api.show, D "Show dependency versions")
    vim.keymap.set({ "n" }, "<leader>nc", api.hide, D "Hide dependency versions")
    vim.keymap.set({ "n" }, "<leader>nt", api.toggle, D "Toggle dependency versions")
    vim.keymap.set({ "n" }, "<leader>nu", api.update, D "Update dependency on the line")
    vim.keymap.set({ "n" }, "<leader>nd", api.delete, D "Delete dependency on the line")
    vim.keymap.set({ "n" }, "<leader>ni", api.install, D "Install a new dependency")
    vim.keymap.set({ "n" }, "<leader>np", api.change_version, D "Install a different dependency version")
  end

  init_window_resize()
  init_dap()
  init_neovide()
  init_tabufline()
  init_telescope()
  init_crates_nvim()
  init_package_info_nvim()
end
