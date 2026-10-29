-- lsp.lua  ──────────────────────────────────────────────────────────╯

return {
  {
    "mason-org/mason.nvim",
    version = "v2.3.1",
    cmd = "Mason",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    version = "v2.3.0",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      { "neovim/nvim-lspconfig", version = "v2.11.0" },
      "saghen/blink.cmp",
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      local servers = {
        "bashls",
        "intelephense",
        "jsonls",
        "lua_ls",
        "ts_ls",
      }

      vim.lsp.config("*", {
      	capabilities = capabilities
      })

      -- A project .luarc.json takes priority over these.
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            telemetry = { enable = false },
            workspace = {
              checkThirdParty = false,
              library = { vim.env.VIMRUNTIME },
            },
          },
        },
      })

      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_enable = false,
      })

      vim.lsp.enable(servers)

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-keymaps", { clear = true }),

        callback = function(args)
          local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = args.buf, desc = desc })
          end

          map("gd", vim.lsp.buf.definition, "Go to definition")

          map("<leader>cf", function()
            vim.lsp.buf.format({ async = true })
          end, "Format buffer")
        end,
      })
    end,
  },
}
