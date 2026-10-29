-- colorscheme.lua  ──────────────────────────────────────────────────╯

-- Modus Operandi in light mode, Catppuccin Mocha in dark mode. Nvim updates
-- 'background' from Ghostty's light/dark theme, and this swaps schemes.
-- "modus" picks Operandi from 'background' and matches g:colors_name.
local schemes = {
  light = "modus",
  dark = "catppuccin-mocha",
}

local function apply(background)
  local name = schemes[background]
  if vim.g.colors_name ~= name then
    vim.cmd.colorscheme(name)
  end
end

return {
  {
    "miikanissi/modus-themes.nvim",
    name = "modus-themes",
    version = "v1.6.0",
    lazy = true,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    version = "v2.0.0",
    lazy = false,
    priority = 1000,
    dependencies = { "modus-themes" },
    opts = {
      flavour = "mocha",
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      -- Match Catppuccin: number and sign columns share the editor
      -- background. Floats stay grey; most have no border.
      require("modus-themes").setup({
        line_nr_column_background = false,
        sign_column_background = false,
      })
      apply(vim.o.background)

      local group = vim.api.nvim_create_augroup("colorscheme-appearance", { clear = true })

      -- OptionSet is silent during startup; catch a late terminal reply.
      vim.api.nvim_create_autocmd("VimEnter", {
        group = group,
        callback = function()
          apply(vim.o.background)
        end,
      })

      -- Reloading a scheme can reset 'background', so use the requested value.
      vim.api.nvim_create_autocmd("OptionSet", {
        group = group,
        pattern = "background",
        callback = function()
          apply(vim.v.option_new)
        end,
      })
    end,
  },
}
