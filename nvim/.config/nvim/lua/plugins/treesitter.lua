-- treesitter.lua  ───────────────────────────────────────────────────╯

return{
	'nvim-treesitter/nvim-treesitter',
	build = ':TSUpdate',
	lazy = false,

	opts = {
      ensure_installed = {
				"zsh",
				"lua",
				"java",
				"php",
				"html",
				"css",
				"javascript",
				"typescript",
				"tsx",
				"json",
				"jsonc",
				"toml",
				"yaml",
				"markdown",
				"markdown_inline",
      },

      highlight = {
        enable = true,
      },

      indent = {
        enable = true,
      },

			folds = {
				enable = true,
			},
    },
}