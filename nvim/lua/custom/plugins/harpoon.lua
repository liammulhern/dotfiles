return {
  'ThePrimeagen/harpoon',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  keys = {
    { 'ma', '<cmd>lua require("harpoon.mark").add_file()<CR>', desc = 'Add file to harpoon' },
    { 'mA', '<cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>', desc = 'Toggle harpoon menu' },
    { 'm1', '<cmd>lua require("harpoon.ui").nav_file(1)<CR>', desc = 'Navigate to file 1' },
    { 'm2', '<cmd>lua require("harpoon.ui").nav_file(2)<CR>', desc = 'Navigate to file 2' },
    { 'm3', '<cmd>lua require("harpoon.ui").nav_file(3)<CR>', desc = 'Navigate to file 3' },
    { 'm4', '<cmd>lua require("harpoon.ui").nav_file(4)<CR>', desc = 'Navigate to file 4' },
  },
}
