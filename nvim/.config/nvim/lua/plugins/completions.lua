-- completions.lua  ──────────────────────────────────────────────────╯

return {
  "saghen/blink.cmp",
  version = "v1.10.2",
  event = "InsertEnter",
  opts = {
    keymap = {
      preset = "none",
      ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-n>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = { "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
    },
    completion = {
      list = { selection = { preselect = false, auto_insert = false } },
    },
  },
}
