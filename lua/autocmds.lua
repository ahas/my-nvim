require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd

autocmd("LspAttach", {
  -- group = vim.api.nvim_create_augroup('MyLspAttach', { clear = true }),
  callback = function(args)
    local bufnr = args.buf

    local function run_code_action(kind)
      vim.lsp.buf.code_action {
        context = {
          only = { kind },
          diagnostics = vim.diagnostic.get(bufnr),
        },
        apply = true,
      }
    end

    local map = function(lhs, kind, desc)
      vim.keymap.set("n", lhs, function() run_code_action(kind) end, { buffer = bufnr, desc = desc })
    end

    map("<leader>fto", "source.organizeImports", "code_action Organize imports")
    map("<leader>fts", "source.sortImports", "code_action Sort imports")
    map("<leader>ftm", "source.addMissingImports", "code_action Add missing imports")
    map("<leader>ftr", "source.removeUnusedImports", "code_action Remove unused imports")
    map("<leader>ftu", "source.removeUnused", "code_action Remove unused symbols")
    map("<leader>fta", "source.fixAll", "code_action Fix all")
  end
})
