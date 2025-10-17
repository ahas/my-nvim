return {
  {
    "nvim-tree/nvim-tree.lua",
    config = function() require "configs.nvim-tree" end,
  },

  {
    "lewis6991/gitsigns.nvim",
  },

  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function() require "configs.lspconfig" end,
  },

  {
    "hrsh7th/nvim-cmp",
    config = function() require "configs.nvim-cmp" end,
  },

  {
    "numToStr/Comment.nvim",
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "css",
          "html",
          "lua",
          "python",
          "rust",
          "scss",
          "sql",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "vimdoc",
          "vue",
          "yaml",
        },
        highlight = {
          enable = true,
        },
      }
    end,
  },

  {
    "numToStr/Comment.nvim",
    lazy = false,
    config = function()
      require("Comment").setup {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
  },

  {
    "vuki656/package-info.nvim",
    lazy = false,
    opts = {
      package_manager = "pnpm",
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    config = function()
      require("telescope").setup {
        -- defaults = {
        --   vimgrep_arguments = {
        --     "rg",
        --     "--color=never",
        --     "--no-heading",
        --     "--with-filename",
        --     "--line-number",
        --     "--column",
        --     "--smart-case",
        --     "--fixed-strings",
        --   },
        -- },
        extensions = {
          package_info = {
            -- Optional theme (the extension doesn't set a default theme)
            theme = "ivy",
          },
        },
      }
      require("telescope").load_extension "package_info"
      -- require "configs.telescope"
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
    config = function() require("nvim-dap-projects").search_project_config() end,
  },

  { "nvim-neotest/nvim-nio" },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function() require("dapui").setup() end,
  },

  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function() require("nvim-dap-virtual-text").setup() end,
  },

  {
    "saecki/crates.nvim",
    lazy = false,
    tag = "stable",
    config = function() require("crates").setup() end,
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function(plugin)
      if vim.fn.executable "npx" then
        vim.cmd("!cd " .. plugin.dir .. " && cd app && npx --yes yarn install")
      else
        vim.cmd [[Lazy load markdown-preview.nvim]]
        vim.fn["mkdp#util#install"]()
      end
    end,
    init = function()
      if vim.fn.executable "npx" then vim.g.mkdp_filetypes = { "markdown" } end
    end,
  },

  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("spectre").setup() end,
  },

  {
    "yioneko/nvim-vtsls",
  },

  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>tt",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>tT",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>ts",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>tl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>tL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>tQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },

  {
    "vyfor/cord.nvim",
    build = ":Cord update",
    -- opts = {}
  },

  {
    "greggh/claude-code.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for git operations
    },
    config = function()
      require("claude-code").setup {
        keymaps = {
          toggle = {
            normal = "<M-,>",
            terminal = "<M-,>",
          },
        },
        window = {
          position = "float",
          float = {
            width = "90%", -- Take up 90% of the editor width
            height = "90%", -- Take up 90% of the editor height
            row = "center", -- Center vertically
            col = "center", -- Center horizontally
            relative = "editor",
            border = "double", -- Use double border style
          },
        },
      }
    end,
  },

  {
    "github/copilot.vim",
    lazy = false,
  },

  {
    "stevearc/overseer.nvim",
    opts = {
      dap = false,
    },
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = function(_, opts)
      -- Other blankline configuration here
      return require("indent-rainbowline").make_opts(opts)
    end,
    dependencies = {
      "TheGLander/indent-rainbowline.nvim",
    },
  },
}
