return {
  'ggandor/leap.nvim',
  dependencies = 'tpope/vim-repeat',
  init = function()
    require('leap').create_default_mappings()
  end,
  keys = {
    { 'gs', '<Plug>(leap)', desc = 'Leap to character', mode = 'n' },
  },
}
