local nvlsp = require "nvchad.configs.lspconfig"
local lspconfig = require "lspconfig"

nvlsp.defaults()

local servers = {
  "pylsp",
  "taplo",
  "css_variables",
  "html",
  "rust_analyzer",
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

lspconfig.cssls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  filetypes = { "css", "less" },
}

lspconfig.somesass_ls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  filetypes = { "scss", "sass" },
}

local mason_registry = require "mason-registry"
local vue_language_server_path = mason_registry.get_package("vue-language-server"):get_install_path()
  .. "/node_modules/@vue/language-server"

lspconfig.ts_ls.setup {
  on_attach = function(client, bufnr)
    nvlsp.on_attach(client, bufnr)
    vim.keymap.set(
      "n",
      "<leader>fo",
      function()
        client:exec_cmd({
          command = "_typescript.organizeImports",
          arguments = { vim.api.nvim_buf_get_name(bufnr) },
        }, { bufnr = bufnr })
      end,
      { noremap = true, silent = true, desc = "LSP Organize Imports", buffer = bufnr }
    )
  end,
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
}

-- No need to set `hybridMode` to `true` as it's the default value
lspconfig.volar.setup {}
