-- ~/.config/nvim/lua/custom/commands.lua

-- Load mason modules safely when needed
local function load_mason_registry()
  local ok, registry = pcall(require, "mason-registry")
  if not ok then
    vim.cmd "Mason" -- triggers lazy-loading of Mason
    ok, registry = pcall(require, "mason-registry")
    if not ok then
      print "Failed to load mason-registry. Is mason.nvim installed?"
      return nil
    end
  end
  return registry
end

-------------------------------------------------
--  MasonExport
-------------------------------------------------
vim.api.nvim_create_user_command("MasonExport", function()
  local registry = load_mason_registry()
  if not registry then return end

  local installed = registry.get_installed_packages()
  local path = vim.fn.stdpath "config" .. "/mason_installed.txt"

  local file = io.open(path, "w")
  if not file then
    print "Failed to write mason_installed.txt"
    return
  end

  for _, pkg in ipairs(installed) do
    file:write(pkg.name .. "\n")
  end

  file:close()
  print("Mason packages exported to: " .. path)
end, {})

-------------------------------------------------
--  MasonRestore (final + correct)
-------------------------------------------------
vim.api.nvim_create_user_command("MasonRestore", function()
  local path = vim.fn.stdpath("config") .. "/mason_installed.txt"
  local file = io.open(path, "r")

  if not file then
    print("mason_installed.txt not found. Run :MasonExport first.")
    return
  end

  vim.cmd("Mason") -- ensure Mason plugin is loaded

  for line in file:lines() do
    local pkg = vim.trim(line)

    if pkg ~= nil and pkg ~= "" then
      local ok = pcall(function()
        vim.cmd("MasonInstall " .. pkg)   -- ← Correct way!
      end)

      if not ok then
        print("Failed to install package: " .. pkg)
      end
    end
  end

  file:close()
  print("Mason packages restored.")
end, {})


-------------------------------------------------
--  MasonReset
-------------------------------------------------
vim.api.nvim_create_user_command("MasonReset", function()
  vim.cmd "Mason" -- ensure Mason is loaded

  local mason_path = vim.fn.stdpath "data" .. "/mason"
  vim.fn.delete(mason_path, "rf")
  print("Mason directory removed: " .. mason_path)

  local path = vim.fn.stdpath "config" .. "/mason_installed.txt"
  local file = io.open(path, "r")

  if not file then
    print "mason_installed.txt not found. Restore skipped."
    return
  end

  print "Restoring Mason packages..."
  for pkg in file:lines() do
    require("mason.api.command").MasonInstall(pkg)
  end

  file:close()
end, {})
