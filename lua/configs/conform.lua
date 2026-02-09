local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettierd", "prettier", stop_after_first = true },
    scss = { "prettierd", "prettier", stop_after_first = true },
    html = { "prettierd", "prettier", stop_after_first = true },
    rust = { "rustfmt" },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    vue = { "prettierd", "prettier", stop_after_first = true },
    python = { "isort", "black" },
  },

  formatters = {
    injected = { options = { ignore_errors = true } },
    rustfmt = {
      -- prepend_args = { "+nightly" }
    },
    black = {
      prepend_args = { "--line-length", "88" },
    },
  },

  -- format_on_save = {
  --   timeout_ms = 2000,
  --   lsp_fallback = true,
  -- },
}

return options
