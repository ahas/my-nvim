require "nvchad.mappings"

local _with_desc = function(opts, desc) return vim.tbl_extend("force", opts, { desc = desc }) end
local map = vim.keymap.set
local del = vim.keymap.del

local M = {}

function M.init()
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

    map("n", "<leader>fD", function() telescope.diagnostics() end, D "telescope diagnostics")
    map(
      "n",
      "<leader>fd",
      function() telescope.diagnostics { bufnr = 0 } end,
      D "telescope diagnostics (current buffer)"
    )
    map("n", "<leader>fr", function() telescope.resume() end, D "telescope resume")
  end

  -- crates.nvim
  local function init_crates_nvim()
    local crates = require "crates"
    local opts = { silent = true }
    local function D(desc) return _with_desc(opts, "Crates " .. desc) end

    map("n", "<leader>ct", crates.toggle, D "Toggle")
    map("n", "<leader>cr", crates.reload, D "Reload")

    map("n", "<leader>cv", crates.show_versions_popup, D "Show versions popup")
    map("n", "<leader>cf", crates.show_features_popup, D "Show features popup")
    map("n", "<leader>cd", crates.show_dependencies_popup, D "Show dependencies popup")

    map("n", "<leader>cu", crates.update_crate, D "Update crate")
    map("v", "<leader>cu", crates.update_crates, D "Update crates")
    map("n", "<leader>ca", crates.update_all_crates, D "Update all crates")
    map("n", "<leader>cU", crates.upgrade_crate, D "Upgrade crate")
    map("v", "<leader>cU", crates.upgrade_crates, D "Upgrade crates")
    map("n", "<leader>cA", crates.upgrade_all_crates, D "Upgrade all crates")

    map("n", "<leader>cx", crates.expand_plain_crate_to_inline_table, D "Expand plain crate to inline table")
    map("n", "<leader>cX", crates.extract_crate_into_table, opts)

    map("n", "<leader>cH", crates.open_homepage, D "Open homepage")
    map("n", "<leader>cR", crates.open_repository, D "Open repository")
    map("n", "<leader>cD", crates.open_documentation, D "Open documentation")
    map("n", "<leader>cC", crates.open_crates_io, D "Open crates.io")
    map("n", "<leader>cL", crates.open_lib_rs, D "Open lib.rs")
  end

  -- package-info.nvim
  local function init_package_info_nvim()
    local api = require "package-info"
    local opts = { silent = true, noremap = true }
    local function D(desc) return _with_desc(opts, "PackageInfo " .. desc) end

    map({ "n" }, "<leader>ns", api.show, D "Show dependency versions")
    map({ "n" }, "<leader>nc", api.hide, D "Hide dependency versions")
    map({ "n" }, "<leader>nt", api.toggle, D "Toggle dependency versions")
    map({ "n" }, "<leader>nu", api.update, D "Update dependency on the line")
    map({ "n" }, "<leader>nd", api.delete, D "Delete dependency on the line")
    map({ "n" }, "<leader>ni", api.install, D "Install a new dependency")
    map({ "n" }, "<leader>np", api.change_version, D "Install a different dependency version")
  end

  -- nvim-spectre
  local function init_spectre()
    local api = require "spectre"
    local opts = { silent = true, noremap = true }
    local function D(desc) return _with_desc(opts, "Spectre " .. desc) end

    map({ "n" }, "<leader>fh", function() api.open() end, D "Find and Replace in Project")
  end

  -- nvim-vtsls
  local function init_vtsls()
    local api = require "vtsls"
    local opts = { silent = true, noremap = true }
    local function D(desc) return _with_desc(opts, "TypeScript " .. desc) end

    map({ "n" }, "<leader>fto", api.commands.organize_imports, D "Organize Imports")
    map({ "n" }, "<leader>ftm", api.commands.organize_imports, D "Add Missing Imports")
    map({ "n" }, "<leader>fts", api.commands.organize_imports, D "Sort Imports")
    map({ "n" }, "<leader>ftu", api.commands.organize_imports, D "Remove Unused Imports")
  end

  -- gitsigns
  local function init_gitsigns()
    local api = require "gitsigns"
    local opts = { silent = true, noremap = true }
    local function D(desc) return _with_desc(opts, "gitsigns " .. desc) end

    -- Navigation
    map({ "n" }, "]c", function()
      if vim.wo.diff then
        vim.cmd.normal { "]c", bang = true }
      else
        api.nav_hunk "next"
      end
    end, D "Next hunk")

    map("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal { "[c", bang = true }
      else
        api.nav_hunk "prev"
      end
    end, D "Previous hunk")

    -- Actions
    map({ "n" }, "<leader>hs", api.stage_hunk, D "Stage hunk")
    map({ "v" }, "<leader>hs", function() api.stage_hunk { vim.fn.line ".", vim.fn.line "v" } end, D "Stage hunk")

    map({ "n" }, "<leader>hr", api.reset_hunk, D "Reset hunk")
    map({ "v" }, "<leader>hr", function() api.reset_hunk { vim.fn.line ".", vim.fn.line "v" } end, D "Reset hunk")

    map({ "n" }, "<leader>hS", api.stage_buffer, D "Stage buffer")
    map({ "n" }, "<leader>hR", api.reset_buffer, D "Reset buffer")
    map({ "n" }, "<leader>hp", api.preview_hunk, D "Preview hunk")
    map({ "n" }, "<leader>hi", api.preview_hunk_inline, D "Preview hunk inline")

    map({ "n" }, "<leader>hb", function() api.blame_line { full = true } end, D "Blame line")

    map({ "n" }, "<leader>hd", api.diffthis, D "Diff this")
    map({ "n" }, "<leader>hD", function() api.diffthis "~" end, D "Diff this")

    map({ "n" }, "<leader>hQ", function() api.setqflist "all" end, D "QuickFix list (all)")
    map({ "n" }, "<leader>hq", api.setqflist, D "QuickFix list")

    -- Toggles
    map({ "n" }, "<leader>tb", api.toggle_current_line_blame, D "Toggle current line blame")
    map({ "n" }, "<leader>tw", api.toggle_word_diff, D "Toggle word diff")

    -- Text object
    map({ "o", "x" }, "ih", api.select_hunk, D "Select hunk")
  end

  init_window_resize()
  init_dap()
  init_neovide()
  init_tabufline()
  init_telescope()
  init_crates_nvim()
  init_package_info_nvim()
  init_spectre()
  init_vtsls()
  init_gitsigns()

  del("n", "<leader>h")
  map("n", ";", ":", { desc = "CMD enter command mode" })
  map("i", "jk", "<ESC>")
end

return M
