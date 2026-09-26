-- options.lua  ─────────────────────────────────────────────────╯

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.breakindent = true
vim.opt.undofile = true

-- indentation options ───────────────────────────────────────────

vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- ui options ────────────────────────────────────────────────────

vim.opt.showmode = false
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

-- search options ────────────────────────────────────────────────

vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

if vim.fn.has("clipboard") == 1 then
  vim.opt.clipboard = "unnamedplus"
end

vim.diagnostic.config({
  severity_sort = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  virtual_text = {
    prefix = "●",
    spacing = 2,
    severity = { min = vim.diagnostic.severity.WARN },
  },
  float = {
    border = "rounded",
    source = "if_many",
  },
})
