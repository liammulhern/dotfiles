return {
  'goolord/alpha-nvim',
  dependencies = { 'echasnovski/mini.icons' },
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    math.randomseed(os.time())

    local function pick_color()
      local colors = { 'String', 'Identifier', 'Keyword', 'Number' }
      return colors[math.random(#colors)]
    end

    local function footer()
      local datetime = os.date ' %d-%m-%Y   %H:%M:%S'
      local version = vim.version()
      local nvim_version_info = '   v' .. version.major .. '.' .. version.minor .. '.' .. version.patch

      return datetime .. nvim_version_info
    end

    local logo = {
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '         .n                   .                 .                  n.        ',
      '  .   .dP                  dP                   9b                 9b.    .  ',
      ' 4    qXb         .       dX                     Xb       .        dXp     t ',
      'dX.    9Xb      .dXb    __                         __    dXb.     dXP     .Xb',
      '9XXb._       _.dXXXXb dXXXXbo.                 .odXXXXb dXXXXb._       _.dXXP',
      ' 9XXXXXXXXXXXXXXXXXXXVXXXXXXXXOo.           .oOXXXXXXXXVXXXXXXXXXXXXXXXXXXXP ',
      "  `9XXXXXXXXXXXXXXXXXXXXX'~   ~`OOO8b   d8OOO'~   ~`XXXXXXXXXXXXXXXXXXXXXP'  ",
      "    `9XXXXXXXXXXXP' `9XX'          `98v8P'          `XXP' `9XXXXXXXXXXXP'    ",
      '        ~~~~~~~       9X.          .db|db.          .XP       ~~~~~~~        ',
      "                        )b.  .dbo.dP'`v'`9b.odb.  .dX(                       ",
      '                      ,dXXXXXXXXXXXb     dXXXXXXXXXXXb.                      ',
      "                     dXXXXXXXXXXXP'   .   `9XXXXXXXXXXXb                     ",
      '                    dXXXXXXXXXXXXb   d|b   dXXXXXXXXXXXXb                    ',
      "                    9XXb'   `XXXXXb.dX|Xb.dXXXXX'   `dXXP                    ",
      "                     `'      9XXXXXX(   )XXXXXXP      `'                     ",
      "                              XXXX X.`v'.X XXXX                              ",
      "                              XP^X'`b   d'`X^XX                              ",
      "                              X. 9  `   '  P )X                              ",
      "                              `b  `       '  d'                              ",
      "                               `             '                               ",
    }

    dashboard.section.header.val = logo
    dashboard.section.header.opts.hl = pick_color()

    dashboard.section.buttons.val = {
      dashboard.button('<Leader>-', '  File Explorer'),
      dashboard.button('<Leader>sf', '  Find File'),
      dashboard.button('<Leader>sg', '  Find Word'),
      dashboard.button('Lazy Update', '  Update plugins', ':Lazy update<cr>'),
      dashboard.button('q', '  Quit', ':qa<cr>'),
    }

    dashboard.section.footer.val = footer()
    dashboard.section.footer.opts.hl = 'Constant'

    alpha.setup(dashboard.opts)

    vim.cmd [[ autocmd FileType alpha setlocal nofoldenable ]]
  end,
}
