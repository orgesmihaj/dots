return {
  "lewis6991/gitsigns.nvim",
  version = "v2.1.0",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    current_line_blame = false,
    on_attach = function(bufnr)
      local gitsigns = require("gitsigns")
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      map("n", "]h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gitsigns.nav_hunk("next")
        end
      end, "Next Git hunk")

      map("n", "[h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gitsigns.nav_hunk("prev")
        end
      end, "Previous Git hunk")

      map("n", "<leader>gp", gitsigns.preview_hunk, "Preview Git hunk")
      map("n", "<leader>gs", gitsigns.stage_hunk, "Stage Git hunk")
      map("n", "<leader>gr", gitsigns.reset_hunk, "Reset Git hunk")
      map("v", "<leader>gs", function()
        gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Stage selected Git hunk")
      map("v", "<leader>gr", function()
        gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Reset selected Git hunk")
      map("n", "<leader>gb", gitsigns.toggle_current_line_blame, "Toggle current-line blame")
      map("n", "<leader>qh", gitsigns.setqflist, "List buffer Git hunks")
    end,
  },
}
