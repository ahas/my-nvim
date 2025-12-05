require("nvchad.configs.lspconfig").defaults()

local function run_code_action(kind, bufnr)
  vim.lsp.buf.code_action {
    context = {
      only = { kind },
      diagnostics = vim.diagnostic.get(bufnr or 0),
    },
    apply = true,
  }
end

local servers = {
  "pylsp",
  "taplo",
  "css_variables",
  "html",
  "rust_analyzer",
  "jsonls",
  "unocss",
}

-- CSS
vim.lsp.config("cssls", {
  filetypes = { "css", "less" },
})
vim.lsp.config("somesass_ls", {
  filetypes = { "scss", "sass" },
})

-- Vue
local vue_language_server_path = vim.fn.expand "$MASON/packages"
  .. "/vue-language-server"
  .. "/node_modules/@vue/language-server"
local tsserver_filetypes =
  { "typescript", "javascript", "javascriptreact", "typescriptreact", "javascript.jsx", "typescript.tsx", "vue" }
local vue_plugin = {
  name = "@vue/typescript-plugin",
  location = vue_language_server_path,
  languages = { "vue" },
  configNamespace = "typescript",
}
local ts_ls_config = {
  init_options = {
    plugins = {
      vue_plugin,
    },
  },
  filetypes = tsserver_filetypes,

  on_attach = function(client, bufnr)
    local map = function(lhs, kind, desc)
      vim.keymap.set("n", lhs, function() run_code_action(kind, bufnr) end, { buffer = bufnr, desc = desc })
    end

    map("<leader>fto", "source.organizeImports", "TS Organize imports")
    map("<leader>fts", "source.sortImports.ts", "TS Sort imports")
    map("<leader>ftm", "source.addMissingImports.ts", "TS Add missing imports")
    map("<leader>ftr", "source.removeUnusedImports.ts", "TS Remove unused imports")
    map("<leader>ftu", "source.removeUnused.ts", "TS Remove unused symbols")
    map("<leader>fta", "source.fixAll.ts", "TS Fix all")
  end,
}
local vue_ls_config = {}

vim.lsp.config("vue_ls", vue_ls_config)
vim.lsp.config("ts_ls", ts_ls_config)
vim.lsp.enable { "ts_ls", "vue_ls" }

-- End of Configs
vim.lsp.enable(servers)
