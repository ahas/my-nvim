require("telescope").setup {
  defaults = {
    file_ignore_patterns = {
      ".git",
      ".nuxt",
      ".nvim",
      ".output",
      ".vscode",
      "node_modules",
      ".env",
      ".env.*",
      ".gitignore",
      ".gitmodules",
      ".prettier*",
      "bun.lockb",
      "tsconfig.*",
      "Cargo.lock",
      "target",
    },
  },
}
