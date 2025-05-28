vim.g.augment_workspace_folders = {
  '~/git/www_tcms3',
  '~/git/tcms3_embedded_workspace',
}

return {
  'augmentcode/augment.vim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    local popup = require 'plenary.popup'
    local augment = require 'augment'

    local chat_history = {
      messages = {},
      position = 0,
    }

    -- Add this function at the top level, before augment_chat_popup
    local function confirm_exit()
      local response = vim.fn.input 'Are you sure you want to exit the current chat session? [Y/n] '
      return response == '' or response:lower():sub(1, 1) == 'y'
    end

    local function augment_chat(message)
      -- Build the command arguments: "chat" is the command key and then the custom message.
      local command_args = 'chat ' .. (message or 'Your custom message here')
      -- Call the plugin's public function using vim.fn; the first argument (0) is a placeholder for the range.
      vim.fn['augment#Command'](0, command_args)
    end

    -- Function to retrieve the text from the current visual selection
    local function get_visual_selection()
      -- Get positions of the visual selection start ('<) and end ('>)
      local s_start = vim.fn.getpos "'<"
      local s_end = vim.fn.getpos "'>"
      local start_line = s_start[2]
      local start_col = s_start[3]
      local end_line = s_end[2]
      local end_col = s_end[3]

      -- Retrieve the selected lines from start_line to end_line
      local lines = vim.fn.getline(start_line, end_line)
      if #lines == 0 then
        return {} -- Return an empty list if nothing was selected
      end
      if type(lines) == 'string' then
        lines = { lines }
      end

      -- Adjust the first and last lines if the selection does not cover full lines
      if #lines == 1 then
        lines[1] = string.sub(lines[1], start_col, end_col)
      else
        lines[1] = string.sub(lines[1], start_col)
        lines[#lines] = string.sub(lines[#lines], 1, end_col)
      end

      return lines -- 'lines' is a list (Lua table) of the selected text      return lines -- 'lines' is a list (Lua table) of the selected text
    end

    local function augment_chat_popup()
      local width = 60
      local height = 10
      local borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' }

      -- Store the current input when navigating history
      local current_input = ''

      local mode = vim.api.nvim_get_mode().mode
      local lines = nil

      -- Get visual selection if in visual mode
      if mode == 'v' or mode == 'V' then
        lines = get_visual_selection()
      end

      -- Create a new buffer for the popup
      local bufnr = vim.api.nvim_create_buf(false, true)

      -- Set initial content including visual selection if present
      local initial_content = {}
      if lines then
        table.insert(initial_content, "The code below is a contextual snippet from user's current file for you to consider for the following request")
        table.insert(initial_content, '')
        table.insert(initial_content, '```')
        for _, line in ipairs(lines) do
          table.insert(initial_content, line)
        end
        table.insert(initial_content, '```')
        table.insert(initial_content, '')
      end
      table.insert(initial_content, '') -- Empty line for user input

      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, initial_content)

      -- Calculate centered position
      local row = math.floor((vim.o.lines - height) / 2)
      local col = math.floor((vim.o.columns - width) / 2)

      local win_id = popup.create(bufnr, {
        title = 'Augment Chat',
        line = row,
        col = col,
        minwidth = width,
        minheight = height,
        borderchars = borderchars,
        border = true,
        borderhighlight = 'TelescopeBorder', -- Border uses Telescope's border style
        focusable = false, -- Prevent focus changes
        noautocmd = true, -- Prevent autocmd events
      })

      -- Function to update buffer content
      local function update_buffer_content(content)
        -- Split content into lines if it contains newlines
        local history_lines = vim.split(content, '\n')
        -- Preserve the '> ' prefix
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, history_lines)
        -- Move cursor to end of last line
        local last_line = #history_lines
        local last_line_length = #history_lines[last_line]
        vim.api.nvim_win_set_cursor(win_id, { last_line, last_line_length })
      end

      -- Create highlight group for prompt symbol
      vim.api.nvim_set_hl(0, 'AugmentPromptSign', { fg = '#87afff', bold = true })

      -- Create namespace for the extmark
      local ns_id = vim.api.nvim_create_namespace 'augment'

      -- Add text properties to protect and highlight the prompt
      vim.api.nvim_buf_set_extmark(bufnr, ns_id, 0, 0, {
        end_col = 0,
        priority = 100,
        right_gravity = false,
        end_right_gravity = false,
        sign_text = '> ',
        sign_hl_group = 'AugmentPromptSign',
      })

      -- Force cursor to start after prompt
      vim.api.nvim_win_set_cursor(win_id, { 1, 2 })

      -- Set window options
      vim.api.nvim_win_set_option(win_id, 'winhl', 'Normal:TelescopeNormal,FloatBorder:TelescopeBorder')

      -- Enable insert mode immediately
      vim.cmd 'startinsert'

      -- Set buffer options
      vim.api.nvim_buf_set_option(bufnr, 'buftype', 'nofile') -- Changed to nofile
      vim.api.nvim_buf_set_option(bufnr, 'bufhidden', 'wipe') -- Added to auto-delete buffer
      vim.api.nvim_buf_set_option(bufnr, 'filetype', 'markdown')

      -- Disable line numbers for this buffer
      vim.api.nvim_win_set_option(win_id, 'number', false)
      vim.api.nvim_win_set_option(win_id, 'relativenumber', false)
      vim.api.nvim_win_set_option(win_id, 'wrap', true)
      vim.api.nvim_win_set_option(win_id, 'linebreak', true)

      -- Handle Enter key to submit
      vim.keymap.set('n', '<CR>', function()
        local content = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        -- Remove the '> ' prefix from the first line
        content[1] = content[1]:gsub('^> ', '')
        local message = table.concat(content, '\n')

        -- Save to history if not empty and not duplicate of last message
        if message and message ~= '' and (not chat_history.messages[#chat_history.messages] or chat_history.messages[#chat_history.messages] ~= message) then
          table.insert(chat_history.messages, message)
        end

        -- Reset history position
        chat_history.position = 0

        -- Close the popup
        vim.api.nvim_win_close(win_id, true)
        -- Call AugmentChat with the buffer contents
        if message and message ~= '' then
          augment_chat(message)
        end
      end, { buffer = bufnr })

      -- Map <Esc> in the popup buffer to close the popup window
      vim.keymap.set('n', '<Esc>', function()
        local confirmed = false
        if confirm_exit() then
          confirmed = true
          vim.api.nvim_win_close(win_id, true)
        end
        -- Clear the prompt line
        vim.api.nvim_command 'echo ""'
        -- If they press Esc again without confirming, close anyway
        if not confirmed then
          vim.keymap.set('n', '<Esc>', function()
            vim.api.nvim_win_close(win_id, true)
          end, { buffer = bufnr, noremap = true, silent = true })
        end
      end, { buffer = bufnr, noremap = true, silent = true })

      -- Add history navigation
      vim.keymap.set('i', '<Up>', function()
        -- Save current input if we're starting to navigate history
        if chat_history.position == 0 then
          current_input = vim.api.nvim_get_current_line():gsub('^> ', '')
        end

        if chat_history.position < #chat_history.messages then
          chat_history.position = chat_history.position + 1
          update_buffer_content(chat_history.messages[#chat_history.messages - chat_history.position + 1])
        end
      end, { buffer = bufnr, noremap = true })

      vim.keymap.set('i', '<Down>', function()
        if chat_history.position > 0 then
          chat_history.position = chat_history.position - 1
          if chat_history.position == 0 then
            -- Restore the current input when we get back to the bottom
            update_buffer_content(current_input)
          else
            update_buffer_content(chat_history.messages[#chat_history.messages - chat_history.position + 1])
          end
        end
      end, { buffer = bufnr, noremap = true })

      -- Create autocmd group for this popup
      local group = vim.api.nvim_create_augroup('AugmentChatPopup' .. bufnr, { clear = true })

      -- Close the popup if the user leaves its window, with confirmation
      vim.api.nvim_create_autocmd({ 'BufLeave', 'WinLeave' }, {
        group = group,
        buffer = bufnr,
        nested = true,
        callback = function()
          if vim.api.nvim_win_is_valid(win_id) then
            if confirm_exit() then
              vim.api.nvim_win_close(win_id, true)
              -- Clean up the autogroup
              vim.api.nvim_del_augroup_by_id(group)
            else
              -- Return to the window if they cancel
              vim.api.nvim_set_current_win(win_id)
              -- Clear the prompt line
              vim.api.nvim_command 'echo ""'
            end
          end
        end,
      })
    end

    -- Create a command to trigger the popup
    vim.api.nvim_create_user_command('AugmentChatPopup', augment_chat_popup, {})
  end,
  keys = {
    { '<leader>ac', '<cmd>AugmentChatPopup<CR>', desc = 'Open Augment Chat popup' },
    { '<leader>at', '<cmd>Augment chat-toggle<CR>', desc = 'Toggle Augment Chat Window' },
  },
}
