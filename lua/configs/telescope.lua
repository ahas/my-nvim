require("telescope").setup {
  defaults = {
    file_ignore_patterns = {
      "\\.git/",
      "\\.nuxt/",
      "\\.nvim/",
      "\\.output/",
      "\\.vscode/",
      "\\.gitignore",
      "\\.gitmodules",
      "\\.prettier*",
      "node_modules/",
      "bun.lockb",
      "tsconfig.*",
      "Cargo.lock",
      "target/",
    },
  },
}
