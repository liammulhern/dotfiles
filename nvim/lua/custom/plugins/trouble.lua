-- Require the plenary.popup module
local popup = require 'plenary.popup'

-- Function to display current line's LSP diagnostics in a popup
local function show_current_line_lsp()
  -- Get the current buffer and cursor position
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local line = cursor_pos[1] - 1 -- zero-indexed line number

  -- Fetch diagnostics for the current line (using the new diagnostic API)
  local diagnostics = vim.diagnostic.get(bufnr, { lnum = line })

  -- If there are no diagnostics, inform the user and exit
  if vim.tbl_isempty(diagnostics) then
    vim.notify('No LSP diagnostics on this line', vim.log.levels.INFO)
    return
  end

  -- Determine the most severe diagnostic to set the border highlight accordingly
  local min_severity = 1000
  for _, diag in ipairs(diagnostics) do
    if diag.severity < min_severity then
      min_severity = diag.severity
    end
  end

  local diag_severity_map = {}
  diag_severity_map[vim.diagnostic.severity.ERROR] = 'E'
  diag_severity_map[vim.diagnostic.severity.WARN] = 'W'
  diag_severity_map[vim.diagnostic.severity.INFO] = 'I'
  diag_severity_map[vim.diagnostic.severity.HINT] = 'H'

  -- Build a list of diagnostic messages
  local diag_lines = {}
  local diag_ranges = {} -- Each entry: { start = <first line index in buffer>, count = <number of lines>, severity = <severity> }``

  for i, diag in ipairs(diagnostics) do
    local start_index = #diag_lines + 1
    -- Split the diagnostic message by newline (if any)
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

  -- Determine the maximum character width among diagnostic lines
  local max_msg_width = 0
  for _, text in ipairs(diag_lines) do
    local line_width = vim.fn.strdisplaywidth(text)
    if line_width > max_msg_width then
      max_msg_width = line_width
    end
  end

  -- Calculate popup dimensions (50% of the screen width, up to 10 lines tall)
  local screen_width = vim.o.columns
  local max_allowed_width = math.floor(screen_width * 0.7)
  local width = math.min(max_allowed_width, max_msg_width)
  local height = math.min(10, #diag_lines)

  -- Create a scratch buffer for the popup window
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, diag_lines)

  -- For each diagnostic range, add highlights for each corresponding line.
  for _, range in ipairs(diag_ranges) do
    local hl_group = ''
    if range.severity == vim.diagnostic.severity.ERROR then
      hl_group = 'DiagnosticError'
    elseif range.severity == vim.diagnostic.severity.WARN then
      hl_group = 'DiagnosticWarn'
    elseif range.severity == vim.diagnostic.severity.INFO then
      hl_group = 'DiagnosticInfo'
    elseif range.severity == vim.diagnostic.severity.HINT then
      hl_group = 'DiagnosticHint'
    else
      hl_group = 'TelescopeNormal'
    end

    for i = range.start, range.start + range.count - 1 do
      -- Note: nvim_buf_add_highlight uses 0-indexed line numbers.
      vim.api.nvim_buf_add_highlight(buf, -1, hl_group, i - 1, 0, -1)
    end
  end

  -- Set popup window options
  local opts = {
    title = 'LSP Diagnostics',
    row = 1,
    col = math.floor((vim.o.columns - width) / 2),
    minwidth = width,
    minheight = height,
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    border = true,
    borderhighlight = 'TelescopeBorder', -- Border uses Telescope's border style
  }

  -- Create the popup and capture its window ID
  local win_id = popup.create(buf, opts)

  -- Map <Esc> in the popup buffer to close the popup window
  vim.keymap.set('n', '<Esc>', function()
    vim.api.nvim_win_close(win_id, true)
  end, { buffer = buf, noremap = true, silent = true })

  -- Map <Enter> in the popup buffer to close the popup window
  vim.keymap.set('n', '<Enter>', function()
    vim.api.nvim_win_close(win_id, true)
  end, { buffer = buf, noremap = true, silent = true })

  -- Close the popup if the user leaves its window
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

-- Create a user command that calls the popup function
vim.api.nvim_create_user_command('LSPDiagPopup', function()
  show_current_line_lsp()
end, { nargs = 0 })

return {
  'folke/trouble.nvim',
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  cmd = 'Trouble',
  keys = {
    {
      '<leader>xx',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = 'Diagnostics (Trouble)',
    },
    {
      '<leader>xX',
      '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
      desc = 'Buffer Diagnostics (Trouble)',
    },
    {
      '<leader>cs',
      '<cmd>Trouble symbols toggle focus=false<cr>',
      desc = 'Symbols (Trouble)',
    },
    {
      '<leader>cl',
      '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
      desc = 'LSP Definitions / references / ... (Trouble)',
    },
    {
      '<leader>xL',
      '<cmd>Trouble loclist toggle<cr>',
      desc = 'Location List (Trouble)',
    },
    {
      '<leader>xQ',
      '<cmd>Trouble qflist toggle<cr>',
      desc = 'Quickfix List (Trouble)',
    },
    {
      '<leader>xe',
      '<cmd>LSPDiagPopup<CR>',
      desc = 'Show error in pop up',
    },
  },
}
