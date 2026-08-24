return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  opts = {
    ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'vim', 'vimdoc', 'typescript', 'javascript', 'svelte' },
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { 'ruby' },
    },
    indent = { enable = true, disable = { 'ruby' } },
  },
  main = 'nvim-treesitter',
  config = function(_, opts)
    vim.filetype.add({ extension = { dbc = 'dbc' } })

    vim.api.nvim_create_autocmd('User', {
      pattern = 'TSUpdate',
      callback = function()
        require('nvim-treesitter.parsers').dbc = {
          install_info = {
            url = 'https://github.com/MerrimanInd/tree-sitter-dbc',
          },
        }
      end,
    })

    require('nvim-treesitter').setup(opts)
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'svelte', 'dbc' },
      callback = function(args)
        local ok, err = pcall(vim.treesitter.start)
        if not ok and args.match == 'dbc' then
          vim.notify('dbc treesitter parser not installed, run :TSInstall dbc', vim.log.levels.WARN)
        elseif not ok then
          error(err)
        end
      end,
    })
  end,
}
