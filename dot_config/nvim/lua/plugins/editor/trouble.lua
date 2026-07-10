return {
  'folke/trouble.nvim',
  cmd = 'Trouble',
  config = function()
    require('trouble').setup {}

    local function show_current_line_lsp()
      local popup = require 'plenary.popup'
      local bufnr = vim.api.nvim_get_current_buf()
      local cursor_pos = vim.api.nvim_win_get_cursor(0)
      local line = cursor_pos[1] - 1

      local diagnostics = vim.diagnostic.get(bufnr, { lnum = line })

      if vim.tbl_isempty(diagnostics) then
        vim.notify('No LSP diagnostics on this line', vim.log.levels.INFO)
        return
      end

      local diag_severity_map = {
        [vim.diagnostic.severity.ERROR] = 'E',
        [vim.diagnostic.severity.WARN] = 'W',
        [vim.diagnostic.severity.INFO] = 'I',
        [vim.diagnostic.severity.HINT] = 'H',
      }

      local diag_lines = {}
      local diag_ranges = {}

      for _, diag in ipairs(diagnostics) do
        local start_index = #diag_lines + 1
        local lines = vim.split(diag.message, '\n')
        for j, l in ipairs(lines) do
          if j == 1 then
            table.insert(diag_lines, string.format('%s. %s', diag_severity_map[diag.severity], l))
          else
            table.insert(diag_lines, '    ' .. l)
          end
        end
        table.insert(diag_ranges, { start = start_index, count = #lines, severity = diag.severity })
      end

      local max_msg_width = 0
      for _, text in ipairs(diag_lines) do
        local line_width = vim.fn.strdisplaywidth(text)
        if line_width > max_msg_width then
          max_msg_width = line_width
        end
      end

      local max_allowed_width = math.floor(vim.o.columns * 0.7)
      local width = math.min(max_allowed_width, max_msg_width)
      local height = math.min(10, #diag_lines)

      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, diag_lines)

      local severity_hl = {
        [vim.diagnostic.severity.ERROR] = 'DiagnosticError',
        [vim.diagnostic.severity.WARN] = 'DiagnosticWarn',
        [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
        [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
      }

      for _, range in ipairs(diag_ranges) do
        local hl_group = severity_hl[range.severity] or 'TelescopeNormal'
        for i = range.start, range.start + range.count - 1 do
          vim.api.nvim_buf_add_highlight(buf, -1, hl_group, i - 1, 0, -1)
        end
      end

      local opts = {
        title = 'LSP Diagnostics',
        row = 1,
        col = math.floor((vim.o.columns - width) / 2),
        minwidth = width,
        minheight = height,
        borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
        border = true,
        borderhighlight = 'TelescopeBorder',
      }

      local win_id = popup.create(buf, opts)

      vim.keymap.set('n', '<Esc>', function()
        vim.api.nvim_win_close(win_id, true)
      end, { buffer = buf, noremap = true, silent = true })

      vim.keymap.set('n', '<Enter>', function()
        vim.api.nvim_win_close(win_id, true)
      end, { buffer = buf, noremap = true, silent = true })

      vim.api.nvim_create_autocmd('WinLeave', {
        buffer = buf,
        once = true,
        callback = function()
          if vim.api.nvim_win_is_valid(win_id) then
            vim.api.nvim_win_close(win_id, true)
          end
        end,
      })
    end

    vim.api.nvim_create_user_command('LSPDiagPopup', function()
      show_current_line_lsp()
    end, { nargs = 0 })
  end,
  keys = {
    { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
    { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
    { '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols (Trouble)' },
    { '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP Definitions / references / ... (Trouble)' },
    { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
    { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
    { '<leader>xe', '<cmd>LSPDiagPopup<CR>', desc = 'Show error in pop up' },
  },
}
