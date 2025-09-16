require("nvchad.configs.lspconfig").defaults()

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
local vue_language_server_path = vim.fn.expand "$MASON/packages"
  .. "/vue-language-server"
  .. "/node_modules/@vue/language-server"
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
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "vue",
  },
}

-- local vue_ls_config = {}
local vue_ls_config = {}

vim.lsp.config("vtsls", vtsls_config)
vim.lsp.config("vue_ls", vue_ls_config)

-- End of Configs
vim.lsp.enable(servers)
