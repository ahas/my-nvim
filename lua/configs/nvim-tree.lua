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
          local filters = vim.tbl_get(client.server_capabilities, "workspace", "fileOperations", "didRename", "filters")
            or {}
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
