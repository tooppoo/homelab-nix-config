vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Use spaces for indentation and keep each indentation level two columns wide.
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2

vim.opt.number = true
vim.opt.list = true
vim.opt.listchars = {
  space = "·",
  tab = "» ",
  eol = "↲",
}

-- nvim-tree replaces netrw as the file explorer.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local uv = vim.uv or vim.loop
if not uv.fs_stat(lazy_path) then
  local result = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazy_path,
  })

  if vim.v.shell_error ~= 0 then
    error("Failed to install lazy.nvim:\n" .. result)
  end
end
vim.opt.rtp:prepend(lazy_path)

require("lazy").setup({
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    cmd = {
      "NvimTreeFocus",
      "NvimTreeOpen",
      "NvimTreeToggle",
    },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
    },
    opts = {},
    config = function(_, opts)
      require("nvim-tree").setup(opts)
    end,
  },
})
