return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",

    -- optional
  },
  opts = {
    workspaces = {
      {
        name = "notes",
        path = "~/workspace/obsidian/",
      },
    },
  },
}
