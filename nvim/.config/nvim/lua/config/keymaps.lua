-- keymaps.lua  ─────────────────────────────────────────────────╯

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap.set

keymap({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

keymap("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })

keymap("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous diagnostic" })

keymap("n", "<leader>qq", vim.cmd.copen, { desc = "Open quickfix list" })
keymap("n", "<leader>ql", vim.cmd.lopen, { desc = "Open location list" })

keymap("n", "<leader>us", function()
  vim.wo.spell = not vim.wo.spell
  vim.notify("Spell checking " .. (vim.wo.spell and "enabled" or "disabled"))
end, { desc = "Toggle spelling" })

keymap("n", "<leader>uw", function()
  vim.wo.wrap = not vim.wo.wrap
  vim.wo.linebreak = vim.wo.wrap
  vim.notify("Line wrapping " .. (vim.wo.wrap and "enabled" or "disabled"))
end, { desc = "Toggle wrapping" })

local prose_state = {}

keymap("n", "<leader>up", function()
  local win = vim.api.nvim_get_current_win()

  if prose_state[win] then
    for option, value in pairs(prose_state[win]) do
      vim.wo[win][option] = value
    end
    prose_state[win] = nil
    vim.notify("Prose mode disabled")
    return
  end

  prose_state[win] = {
    colorcolumn = vim.wo[win].colorcolumn,
    cursorline = vim.wo[win].cursorline,
    linebreak = vim.wo[win].linebreak,
    number = vim.wo[win].number,
    relativenumber = vim.wo[win].relativenumber,
    signcolumn = vim.wo[win].signcolumn,
    spell = vim.wo[win].spell,
    wrap = vim.wo[win].wrap,
  }

  vim.wo[win].colorcolumn = ""
  vim.wo[win].cursorline = false
  vim.wo[win].linebreak = true
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = "no"
  vim.wo[win].spell = true
  vim.wo[win].wrap = true
  vim.notify("Prose mode enabled")
end, { desc = "Toggle distraction-free prose mode" })
