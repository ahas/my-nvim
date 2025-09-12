local cmp = require "cmp"
local conf = require "nvchad.configs.cmp"

local mappings = {
  ["<Tab>"] = nil,
  ["<S-Tab>"] = nil,

  ["<C-h>"] = cmp.mapping.open_docs(),
  ["<C-f>"] = cmp.mapping.scroll_docs(-4),
  ["<C-b>"] = cmp.mapping.scroll_docs(4),
  ["<C-u>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item { count = math.floor(#cmp.get_entries() / 2) }
    else
      fallback()
    end
  end),
  ["<C-d>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item { count = math.floor(#cmp.get_entries() / 2) }
    else
      fallback()
    end
  end),
  ["<C-j>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
    elseif require("luasnip").expand_or_jumpable() then
      require("luasnip").expand_or_jump()
    else
      fallback()
    end
  end, { "i", "s" }),
  ["<C-k>"] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    elseif require("luasnip").jumpable(-1) then
      require("luasnip").jump(-1)
    else
      fallback()
    end
  end, { "i", "s" }),
}

conf.mapping = vim.tbl_deep_extend("force", conf.mapping, mappings)

conf.window.completion = cmp.config.window.bordered()
conf.window.documentation = cmp.config.window.bordered()

cmp.setup(conf)
