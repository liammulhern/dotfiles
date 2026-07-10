return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-neotest/neotest-python',
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-python' {
          runner = 'pytest',
        },
      },
    }

    vim.keymap.set('n', '<leader>tn', ":lua require('neotest').run.run()<CR>", { desc = 'Run Test' })
    vim.keymap.set('n', '<leader>tf', ":lua require('neotest').run.run(vim.fn.getcwd())<CR>", { desc = 'Run Test Directory' })
    vim.keymap.set('n', '<leader>td', ":lua require('neotest').run.run({ strategy = 'dap' })<CR>", { desc = 'Run Test Debug' })
  end,
}
