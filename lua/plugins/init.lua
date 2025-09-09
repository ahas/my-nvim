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

          -- vtsls integrations
          local path_sep = package.config:sub(1, 1)

          local function trim_sep(path) return path:gsub(path_sep .. "$", "") end

          local function uri_from_path(path) return vim.uri_from_fname(trim_sep(path)) end

          local function is_sub_path(path, folder)
            path = trim_sep(path)
            folder = trim_sep(folder)
            if path == folder then
              return true
            else
              return path:sub(1, #folder + 1) == folder .. path_sep
            end
          end

          local function check_folders_contains(folders, path)
            for _, folder in pairs(folders) do
              if is_sub_path(path, folder.name) then return true end
            end
            return false
          end

          local function match_file_operation_filter(filter, name, type)
            if filter.scheme and filter.scheme ~= "file" then
              -- we do not support uri scheme other than file
              return false
            end
            local pattern = filter.pattern
            local matches = pattern.matches

            if type ~= matches then return false end

            local regex_str = vim.fn.glob2regpat(pattern.glob)
            if vim.tbl_get(pattern, "options", "ignoreCase") then regex_str = "\\c" .. regex_str end
            return vim.regex(regex_str):match_str(name) ~= nil
          end

          api.events.subscribe(api.events.Event.NodeRenamed, function(data)
            local stat = vim.loop.fs_stat(data.new_name)
            if not stat then return end
            local type = ({ file = "file", directory = "folder" })[stat.type]
            local clients = vim.lsp.get_clients {}
            for _, client in ipairs(clients) do
              if check_folders_contains(client.workspace_folders, data.old_name) then
                local filters = vim.tbl_get(
                  client.server_capabilities,
                  "workspace",
                  "fileOperations",
                  "didRename",
                  "filters"
                ) or {}
                for _, filter in pairs(filters) do
                  if
                    match_file_operation_filter(filter, data.old_name, type)
                    and match_file_operation_filter(filter, data.new_name, type)
                  then
                    client:notify(
                      "workspace/didRenameFiles",
                      { files = { { oldUri = uri_from_path(data.old_name), newUri = uri_from_path(data.new_name) } } }
                    )
                  end
                end
              end
            end
          end)
        end,
        view = {
          width = 36,
        },
        update_focused_file = {
          enable = true,
          update_root = false,
        },
        filters = {
          dotfiles = false,
          git_ignored = false,
        },
      }
    end,
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
    opts = function()
      local cmp = require "cmp"
      local conf = require "nvchad.configs.cmp"

      local mappings = {
        ["<Tab>"] = nil,
        ["<S-Tab>"] = nil,

        ["<C-h>"] = cmp.mapping.open_docs(),
        ["<C-f>"] = cmp.mapping.scroll_docs(-4),
        ["<C-b>"] = cmp.mapping.scroll_docs(4),
        ["<C-g>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item { count = cmp.get_selected_index() + 1 }
          else
            fallback()
          end
        end),
        -- ["<S-g>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_next_item { count = #cmp.get_entries() - cmp.get_selected_index() }
        --   else
        --     fallback()
        --   end
        -- end),
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

      return conf
    end,
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
          "vim",
          "lua",
          "vimdoc",
          "html",
          "css",
          "scss",
          "vue",
          "typescript",
          "rust",
          "python",
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
      package_manager = "bun",
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
    "stevearc/overseer.nvim",
    opts = {
      dap = false,
    },
  },
}
