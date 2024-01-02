-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- Workspaces
  'natecraddock/workspaces.nvim',
  'natecraddock/sessions.nvim',

  {
    'nvim-tree/nvim-tree.lua',
    version = "",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {}
  },

  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {}
  },

  {
    'rcarriga/nvim-dap-ui',
    dependencies = 'mfussenegger/nvim-dap',
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      print("hello")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.after.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end
  },
  vim.keymap.set('n', '<leader>so', '<cmd>ObsidianSearch<CR>', { desc = '[S]earch [O]bsidian Note' })
}
