-- lsp.lua  ──────────────────────────────────────────────────────────╯

return {
  {
    "mason-org/mason.nvim",
    version = "v2.3.1",
    lazy = false,
    opts = {},
    config = function(_, opts)
      require("mason").setup(opts)

      local registry = require("mason-registry")
      registry.refresh(function(ok)
        if not ok then
          vim.schedule(function()
            vim.notify("Mason registry refresh failed; check network access", vim.log.levels.ERROR)
          end)
          return
        end

        if not registry.is_installed("php-debug-adapter") then
          registry.get_package("php-debug-adapter"):install(nil, function(success)
            vim.schedule(function()
              vim.notify(
                success and "Installed PHP debug adapter" or "PHP debug adapter installation failed",
                success and vim.log.levels.INFO or vim.log.levels.ERROR
              )
            end)
          end)
        end
      end)
    end,
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
      }

      vim.lsp.config("*", { capabilities = capabilities })
      vim.lsp.config("lua_ls", {
        on_init = function(client)
          local folder = client.workspace_folders and client.workspace_folders[1]
          local path = folder and vim.uri_to_fname(folder.uri)

          if path and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc")) then
            return
          end

          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua or {}, {
            runtime = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              library = { vim.env.VIMRUNTIME },
            },
          })
        end,
        settings = {
          Lua = {
            telemetry = { enable = false },
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
          map("gr", vim.lsp.buf.references, "Find references")
          map("gI", vim.lsp.buf.implementation, "Go to implementation")
          map("K", vim.lsp.buf.hover, "Show hover documentation")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>cf", function()
            vim.lsp.buf.format({ async = true })
          end, "Format buffer")
        end,
      })
    end,
  },
}
