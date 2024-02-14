return {
  -- Workspaces
  {
    'natecraddock/workspaces.nvim',
    config = function()
      local workspaces = require("workspaces")
      workspaces.setup()
      -- Table length calculation (for workspaces.add;)
      local function tableLength(t)
        local count = 0
        for _ in pairs(t) do count = count + 1 end
        return count
      end

      -- Workspaces shorthand user commands
      vim.api.nvim_create_user_command('Wsa', function(opts)
        local argLength = tableLength(opts.fargs)
        if argLength == 0 then
          workspaces.add()
        elseif argLength == 1 then
          workspaces.add(opts.fargs[1])
        elseif argLength == 2 then
          workspaces.add(opts.fargs[1], opts.fargs[2])
        else
          print(string.format("wrong number of arguments: %s", argLength))
        end
      end, { nargs = '*' })

      vim.api.nvim_create_user_command('Wso', function(opts)
        if opts.args == '' then
          workspaces.open()
        else
          workspaces.open(opts.args)
        end
      end, { nargs = '?' })

      vim.api.nvim_create_user_command('Wsr', function(opts)
        if opts.args == '' then
          workspaces.remove()
        else
          workspaces.remove(opts.args)
        end
      end, { nargs = '?' })

        end
  },
  {'natecraddock/sessions.nvim',
    config = function()
      require("sessions").setup()
    end
  },
}
