require("nvchad.configs.lspconfig").defaults()

local utils = require "utils"

local servers = {
  "pylsp",
  "taplo",
  "css_variables",
  "html",
  "rust_analyzer",
  "jsonls",
  "unocss",
  "vtsls",
  "vue_ls",
}

-- CSS
vim.lsp.config("cssls", {
  filetypes = { "css", "less" },
})
vim.lsp.config("somesass_ls", {
  filetypes = { "scss", "sass" },
})

-- Vue
local mason_dir = vim.fs.joinpath(utils.is_windows() and vim.env.MASON or "$MASON", "packages")
local vue_language_server_path =
  vim.fs.joinpath(mason_dir, "vue-language-server", "node_modules", "@vue/language-server")
local tsserver_filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" }
local vue_plugin = {
  name = "@vue/typescript-plugin",
  location = vue_language_server_path,
  languages = { "vue" },
  configNamespace = "typescript",
}
local vtsls_config = {
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          vue_plugin,
        },
      },
    },
  },
  filetypes = tsserver_filetypes,
}

-- local vue_ls_config = {}
local vue_ls_config = {}

vim.lsp.config("vtsls", vtsls_config)
vim.lsp.config("vue_ls", vue_ls_config)

-- End of Configs
vim.lsp.enable(servers)
