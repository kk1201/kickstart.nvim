return {
    {
        -- Workspaces
        'natecraddock/workspaces.nvim',
        config = function()
            local workspaces = require("workspaces")
            workspaces.setup({
                -- Set up sessions.nvim integration
                hooks = {
                    open_pre = {
                        "SessionsStop",
                        "silent %bdelete",
                    },
                    open = function()
                        require("sessions").load(nil, { silent = true })
                    end,
                }
            })
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
    {
        'natecraddock/sessions.nvim',
        config = function()
            require("sessions").setup({
                events = { "WinEnter" },
                session_filepath = ".nvim/session"
            })
        end,
    },
    {
        "mrcjkb/rustaceanvim",
        version = "^3", -- Recommended
        ft = { "rust" },
        init = function()
            vim.g.rustaceanvim = {
                -- Plugin configuration
                tools = {
                    autoSetHints = true,
                    inlay_hints = {
                        show_parameter_hints = true,
                        parameter_hints_prefix = "<- ",
                        other_hints_prefix = "=> ",
                    },
                },
                server = {
                    on_attach = function(client, bufnr)
                        -- require("illuminate").on_attach(client)
                        local bufopts = {
                            noremap = true,
                            silent = true,
                            buffer = bufnr,
                        }
                        vim.keymap.set("n", "<leader><leader>rr", "<Cmd>RustLsp runnables<CR>", bufopts)
                        vim.keymap.set("n", "K", "<Cmd>RustLsp hover actions<CR>", bufopts)
                    end,
                    settings = {
                        -- rust-analyzer language server configuration
                        ["rust-analyzer"] = {
                            assist = {
                                importEnforceGranularity = true,
                                importPrefix = "create",
                            },
                            cargo = { allFeatures = true },
                            checkOnSave = {
                                -- default: `cargo check` but `clippy` can be used too.
                                command = "cargo check",
                                allFeatures = true,
                            },
                            inlayHints = {
                                lifetimeElisionHints = {
                                    enable = true,
                                    useParameterNames = true,
                                },
                            },
                        },
                    },
                },
            }
        end,
    },
    {
        "ThePrimeagen/harpoon",
        -- optional for icon support
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { tabline = true },
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup({ settings = { save_on_toggle = true, sync_on_ui_close = true } })

            vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end)
            vim.keymap.set("n", "<leader>r", function() harpoon:list():remove() end)
            vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

            vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
            vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
            vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
            vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)
            vim.keymap.set("n", "<leader>5", function() harpoon:list():select(5) end)
            vim.keymap.set("n", "<leader>6", function() harpoon:list():select(6) end)
            vim.keymap.set("n", "<leader>7", function() harpoon:list():select(7) end)
            vim.keymap.set("n", "<leader>8", function() harpoon:list():select(8) end)

            -- Toggle previous & next buffers stored within Harpoon list
            vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
            vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

            require("telescope").load_extension("harpoon")
        end
    }
}
