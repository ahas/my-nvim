require "nvchad.options"

local o = vim.opt

o.colorcolumn = "108"

-- neovide
if vim.g.neovide then
  o.guifont = "BlexMono Nerd Font,D2Coding:h12:e-antialiasing"
  vim.g.neovide_scale_factor = 1.0
  vim.g.neovide_title_background_color =
    string.format("%x", vim.api.nvim_get_hl(0, { id = vim.api.nvim_get_hl_id_by_name "Normal" }).bg)
  vim.g.neovide_title_text_color = "#ffffff"
  vim.g.neovide_cursor_smooth_blink = true
  vim.g.neovide_scroll_animation_length = 0.2
  vim.g.neovide_remember_window_size = false
  vim.g.neovide_cursor_vfx_mode = "pixiedust"
end
