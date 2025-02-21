return {
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup {
        on_attach = function(bufnr)
          local api = require "nvim-tree.api"

          local function opts(desc)
            return { desc = "Nvimtree " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end

          api.config.mappings.default_on_attach(bufnr)

          -- delete default key mappings
          vim.keymap.del("n", "<C-e>", { buffer = bufnr })
          vim.keymap.del("n", "H", { buffer = bufnr })
          vim.keymap.del("n", "M", { buffer = bufnr })
          vim.keymap.del("n", "L", { buffer = bufnr })

          vim.keymap.set({ "n", "v" }, "<C-e>", "1<C-e>", opts "Scroll down")
          vim.keymap.set({ "n", "v" }, "M", "M", opts "Goto middle")
          vim.keymap.set({ "n", "v" }, "L", "L", opts "Goto bottom")
          vim.keymap.set("n", "<C-H>", api.tree.toggle_hidden_filter, opts "Toggle Filter: Dotfiles")
        end,
        view = {
          width = 36,
        },
        update_focused_file = {
          enable = true,
          update_root = true,
        },
      }
    end,
  },

  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "vue",
        "typescript",
        "rust",
      },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    config = function()
      require "configs.telescope"
    end,
  },

  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = {
      { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = {},
  },

  {
    "ldelossa/nvim-dap-projects",
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = "ldelossa/nvim-dap-projects",
    config = function()
      require("nvim-dap-projects").search_project_config()
    end,
  },

  { "nvim-neotest/nvim-nio" },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      require("dapui").setup()
    end,
  },

  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("nvim-dap-virtual-text").setup()
    end,
  },

  {
    "smoka7/multicursors.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvimtools/hydra.nvim",
    },
    opts = {},
    cmd = { "MCstart", "MCvisual", "MCclear", "MCpattern", "MCvisualPattern", "MCunderCursor" },
    keys = {
      {
        mode = { "v", "n" },
        "<Leader>m",
        "<cmd>MCstart<cr>",
        desc = "Create a selection for selected text or word under the cursor",
      },
    },
  },

  {
    "RRethy/vim-illuminate",
  },

  {
    "windwp/nvim-autopairs",
    enabled = false,
  },
}
