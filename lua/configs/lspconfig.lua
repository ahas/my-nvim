local nvlsp = require "nvchad.configs.lspconfig"
local lspconfig = require "lspconfig"

nvlsp.defaults()

local servers = {
  "pylsp",
  "taplo",
  "cssls",
  "css_variables",
  "html",
  "rust_analyzer",
  "somesass_ls",
  "jsonls",
  "unocss",
}

-- local function on_attach(client, bufnr)
--   nvlsp.on_attach(client, bufnr)
--   require("mappings").init()
-- end

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- typescript
local mason_registry = require "mason-registry"
local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path()
  .. "/node_modules/@vue/language-server"

lspconfig.ts_ls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,

  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = vue_language_server_path,
        languages = { "vue" },
      },
    },
  },

  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },

  commands = {
    OrganizeImports = {
      function()
        local params = {
          command = "_typescript.organizeImports",
          arguments = { vim.api.nvim_buf_get_name(0) },
          title = "",
        }
        vim.lsp.buf.execute_command(params)
      end,
      description = "Organize Imports",
    },
  },
}
