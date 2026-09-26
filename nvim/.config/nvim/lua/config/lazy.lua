-- lazy.lua  ────────────────────────────────────────────────────╯

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  if vim.fn.executable("git") ~= 1 then
    error("lazy.nvim bootstrap requires Git in PATH")
  end

  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=v11.17.5",
    lazyrepo,
    lazypath,
  })

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
    }, true, {})
    error("lazy.nvim bootstrap failed; check Git and network access")
  end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  change_detection = {
    notify = false,
  },
  checker = { enabled = false },
  pkg = { sources = { "lazy" } },
})
