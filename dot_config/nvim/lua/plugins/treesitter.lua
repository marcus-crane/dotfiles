-- contains treesitter languages
return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vento",
        "html",
        "javascript",
      },
    },
  },
}
