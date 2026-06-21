return {
  'lervag/vimtex',
  lazy = false, -- we don't want to lazy load VimTeX
  init = function()
    vim.g.vimtex_view_method = 'zathura'
    vim.g.vimtex_compiler_method = 'latexmk'
    -- tell vimtex/latexmk to use -shell-escape
    vim.g.vimtex_compiler_latexmk = {
      build_dir = 'build', -- optional: put aux files beside .tex
      callback = 1, -- open quickfix on errors
      continuous = 1, -- keep running latexmk
      executable = 'latexmk',
      options = {
        '-pdf',
        '-shell-escape',
        '-file-line-error',
        '-synctex=1',
        '-interaction=nonstopmode',
      },
    }
  end,
}
