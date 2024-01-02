return {
  "epwalsh/obsidian.nvim",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim"
  },

  opts = {
    workspaces = {
      {
        name = "myNotes",
        path = "~\\Dropbox\\Dropbox Obsidian"
      }
    }
  },
  -- mappings = {
  --   ["gf"] = {
  --     action = function()
  --       return require("obsidian").util.gf_passthrough()
  --     end,
  --     opts = { noremap = false, expr = true, buffer = true }
  --   }
  -- }
  vim.keymap.set('n', '<leader>so', '<cmd>ObsidianSearch<CR>', { desc = '[S]earch [O]bsidian Note' })
}
