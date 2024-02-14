-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == '' then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    print 'Not a git repository. Searching on current working directory'
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep {
      search_dirs = { git_root },
    }
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

local function telescope_live_grep_open_files()
  require('telescope.builtin').live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end
vim.keymap.set('n', '<leader>s/', telescope_live_grep_open_files, { desc = '[S]earch [/] in Open Files' })
vim.keymap.set('n', '<leader>ss', require('telescope.builtin').builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })

-- Automatic search highlight switching
local ns = vim.api.nvim_create_namespace('toggle_hlsearch')

local function toggle_hlsearch(char)
  if vim.fn.mode() == 'n' then
    local keys = { '<CR>', 'n', 'N', '*', '#', '?', '/' }
    local new_hlsearch = vim.tbl_contains(keys, vim.fn.keytrans(char))

    if vim.opt.hlsearch:get() ~= new_hlsearch then
      vim.opt.hlsearch = new_hlsearch
    end
  end
end

vim.on_key(toggle_hlsearch, ns)

require("nvim-tree").setup()
-- local treeApi = require("nvim-tree.api")

vim.api.nvim_create_user_command('Tsb', 'tab sb', {})
vim.api.nvim_create_user_command('Conf', string.format("tabe %s/init.lua", vim.fn.stdpath('config')), {})
vim.keymap.set('n', 'gh', function() vim.api.nvim_command('ClangdSwitchSourceHeader') end)
vim.keymap.set('n', ';', ':')
vim.keymap.set('n', '<leader>tc', '<cmd> tcd %:p:h <CR>', { noremap = true })
-- vim.keymap.set('n', '<F5>', function() treeApi.tree.toggle() end)
-- vim.keymap.set('n', '<C-F5>', function() treeApi.tree.find_file(vim.fn.expand('%:p')) end)
vim.keymap.set('n', '<F6>', function() vim.fn['tagbar#ToggleWindow']() end)
vim.keymap.set('n', '<C-w><C-f>', '<C-w>vgf <C-w>L', { noremap = true })
vim.keymap.set('n', 'gf',
  function()
    if require("obsidian").util.cursor_on_markdown_link() then
      return "<cmd>ObsidianFollowLink<CR>"
    else
      return "gf"
    end
  end, { noremap = false, expr = true }
)
vim.keymap.set('n', '<leader>db', '<cmd> DapToggleBreakpoint <CR>', { noremap = true })
vim.keymap.set('n', '<F7>', '<cmd> DapContinue <CR>', { noremap = true })
vim.keymap.set('n', '<F9>', '<cmd> DapToggleBreakpoint <CR>', { noremap = true })
vim.keymap.set('n', '<F10>', '<cmd> DapStepOver <CR>', { noremap = true })
vim.keymap.set('n', '<F11>', '<cmd> DapStepInto <CR>', { noremap = true })
vim.keymap.set('n', '<S-F11>', '<cmd> DapStepOut <CR>', { noremap = true })
vim.keymap.set('n', '<S-PageDown>', '<cmd> :bnext <CR>', { noremap = true })
vim.keymap.set('n', '<S-PageUp>', '<cmd> :bprevious <CR>', { noremap = true })
vim.keymap.set('n', '<leader>dt', function()
    require("dapui").float_element('stacks', { width = 20, height = 10, enter = true, position = nil })
  end)
vim.keymap.set('n', '<leader>sb', function()
    require("buffer_manager.ui").toggle_quick_menu()
  end)
vim.keymap.set('i', '<S-Insert>', '<C-R>+', { noremap = true, silent = true })
vim.keymap.set('n', '<S-Insert>', '"+p', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>tlb', function()
  require('telescope.builtin').buffers({ only_cwd = vim.fn.haslocaldir() == 1 })
  end)
vim.keymap.set('n', "<leader>hrp", function()
  local function callback(input)
    if (input ~= nil) then
      local num = tonumber(input)
      if (num ~= nil) then
        require("harpoon.ui").nav_file(input)
      end
    end
  end
  vim.ui.input( { prompt = "Where to?: "}, callback)
end)
vim.keymap.set('n', "<leader><F1>", function() require("harpoon.ui").toggle_quick_menu() end)
vim.keymap.set('n', "<leader><F2>", function() require("harpoon.mark").toggle_file() end)
