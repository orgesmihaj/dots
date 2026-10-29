-- treesitter.lua  ───────────────────────────────────────────────────╯

-- Nvim bundles lua, markdown, and markdown_inline.
local parsers = {
  "bash",
  "javascript",
  "json",
  "php",
  "tsx",
  "typescript",
  "zsh",
}

local filetypes = {
  "bash",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "lua",
  "markdown",
  "php",
  "sh",
  "typescript",
  "typescriptreact",
  "zsh",
}

return {
  "nvim-treesitter/nvim-treesitter",
  commit = "7248feaca45e4d944591497964bc19afa89ad1c6",
  build = ":TSUpdate",
  lazy = false,

  config = function()
    require("nvim-treesitter").install(parsers)

    local group = vim.api.nvim_create_augroup("treesitter-config", { clear = true })

    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = filetypes,
      callback = function(args)
        if not pcall(vim.treesitter.start, args.buf) then
          return
        end

        if vim.bo[args.buf].filetype ~= "markdown" then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      end,
    })
  end,
}
