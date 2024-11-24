--------------
-- obsidian --
--------------
--
-- >>> oo # from shell, navigate to vault (optional)
--
-- # NEW NOTE
-- >>> on "Note Name" # call my "obsidian new note" shell script (~/bin/on)
-- >>>
-- >>> ))) <leader>on # inside vim now, format note as template
-- >>> ))) # add tag, e.g. fact / blog / video / etc..
-- >>> ))) # add hubs, e.g. [[python]], [[machine-learning]], etc...
-- >>> ))) <leader>of # format title
--
-- # END OF DAY/WEEK REVIEW
-- >>> or # review notes in inbox
-- >>>
-- >>> ))) <leader>ok # inside vim now, move to zettelkasten
-- >>> ))) <leader>odd # or delete
-- >>>
-- >>> og # organize saved notes from zettelkasten into notes/[tag] folders
-- >>> ou # sync local with Notion
--
-- navigate to vault
vim.keymap.set('n', '<leader>oo', ':cd C:\\Users\\LiamM\\Documents\\Notes<cr>', { desc = '[O]bsidian [O]pen notes' })
--
-- convert note to template and remove leading white space
vim.keymap.set('n', '<leader>on', ':ObsidianTemplate note<cr> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<cr>', { desc = '[O]bsidian [N]ote template' })
-- strip date from note title and replace dashes with spaces
-- must have cursor on title
vim.keymap.set('n', '<leader>of', ':s/\\(# \\)[^_]*_/\\1/ | s/-/ /g<cr>', { desc = '[O]bsidian [F]ormat note title' })
--
-- search for files in full vault
vim.keymap.set(
  'n',
  '<leader>os',
  ':Telescope find_files search_dirs={"C:\\Users\\LiamM\\Documents\\Notes"}<cr>',
  { desc = '[O]bsidian Telescope Note [S]earch' }
)
vim.keymap.set(
  'n',
  '<leader>oz',
  ':Telescope live_grep search_dirs={"C:\\Users\\LiamM\\Documents\\Notes"}<cr>',
  { desc = '[O]bsidian Telescope [Z] Grep Search' }
)
--
-- for review workflow
-- move file in current buffer to zettelkasten folder
vim.keymap.set(
  'n',
  '<leader>ok',
  ":!mv '%:p' C:\\Users\\LiamM\\Documents\\Notes\\99-zettelkasten\\<cr>:bd<cr>",
  { desc = '[O]bsidian move note to Zettel[K]asten' }
)
-- delete file in current buffer
vim.keymap.set('n', '<leader>odd', ":!rm '%:p'<cr>:bd<cr>", { desc = '[O]bsidian [DD]elete note' })
