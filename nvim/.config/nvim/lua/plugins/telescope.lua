return {
  "nvim-telescope/telescope.nvim",
  version = "v0.2.2",
  cmd = "Telescope",
  dependencies = {
    { "nvim-lua/plenary.nvim", version = "v0.1.4" },
  },
  keys = {
    { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find files" },
    { "<leader>fg", function() require("telescope.builtin").live_grep() end, desc = "Live grep" },
    { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Find buffers" },
    { "<leader>fd", function() require("telescope.builtin").diagnostics() end, desc = "Find diagnostics" },
    { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Find help" },
    { "<leader>fr", function() require("telescope.builtin").oldfiles() end, desc = "Recent files" },
    { "<leader>fw", function() require("telescope.builtin").grep_string() end, desc = "Find word under cursor" },
  },
  opts = {
    defaults = {
      mappings = {
        i = { ["<C-u>"] = false, ["<C-d>"] = false },
      },
    },
  },
}
