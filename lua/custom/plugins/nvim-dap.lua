return {
  "mfussenegger/nvim-dap",
  config = function()
    local dap = require("dap")

    dap.adapters.cppdbg = {
      id = 'cppdbg',
      type = 'executable',
      command =
      'C:\\Users\\k\\AppData\\Local\\nvim-data\\mason\\packages\\cpptools\\extension\\debugAdapters\\bin\\OpenDebugAD7.exe',
      options = {
        detached = false
      }
    }

    local lastProgram
    local previousCwd
    vim.g.c_syntax_for_h = 1
    dap.configurations.c = {
      {
        name = "Launch file",
        type = "cppdbg",
        request = "launch",
        console = "integratedTerminal",
        program = function()
          local folderName
          for w in string.gmatch(vim.fn.getcwd(), "[^\\]+") do
            if w ~= nil then
              folderName = w
            end
          end
          print(folderName)

          if folderName == "src" then
            previousCwd = vim.fn.getcwd()
            vim.api.nvim_set_current_dir(vim.fn.expand('../build'))
          else
            previousCwd = vim.fn.getcwd()
            -- local buildDir = vim.fn.systemlist('Get-ChildItem -Path ' .. vim.fn.getcwd() .. ' build -recurse -Name')[1]
            local buildDir = vim.fn.system("Get-ChildItem -Path F:\\learning\\LearnOpenGL\\Mingw build -recurse")
            -- print(buildDir .. " " .. previousCwd)
            print("current dir: " .. previousCwd)
            print("build dir: " .. buildDir)
            vim.api.nvim_set_current_dir(buildDir);
          end

          lastProgram = vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          return lastProgram -- vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = function()
          if '${workspaceFolderBasename}' == "src" then
            vim.api.nvim_set_current_dir(vim.fn.expand('../build'))
            return vim.fn.getcwd()
          else
            return vim.fn.getcwd()
          end
        end,
        stopAtEntry = true,
        setupCommands = {
          {
            text = '-enable-pretty-printing',
            description = 'enable pretty printing',
            ignoreFailures = false
          },
        },
      },

      {
        name = "Launch last file",
        type = "cppdbg",
        request = "launch",
        program = function()
          return lastProgram
        end,
        cwd = '${workspaceFolder}',
        stopAtEntry = true,
        -- setupCommands = {
        --   {
        --      text = '-enable-pretty-printing',
        --      description =  'enable pretty printing',
        --      ignoreFailures = false
        --   },
        -- }
      },

      {
        name = 'Attach to gdbserver :1234',
        type = 'cppdbg',
        request = 'launch',
        MIMode = 'gdb',
        miDebuggerServerAddress = 'localhost:1234',
        miDebuggerPath = 'C:\\msys64\\ucrt64\\bin\\gdb.exe',
        cwd = '${workspaceFolder}',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        -- setupCommands =   {
        --   {
        --      text = '-enable-pretty-printing',
        --      description =  'enable pretty printing',
        --      ignoreFailures = false
        --   },
        -- },
      },

    }
    dap.configurations.cpp = dap.configurations.c
  end
}
