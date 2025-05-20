local Terminal = require('toggleterm.terminal').Terminal

local lazygit = Terminal:new({ cmd = 'lazygit', hidden = true })
vim.keymap.set('n', '<leader>tg', function() lazygit:toggle() end, { desc = 'Open lazygit [toggleterm]' })

local yazi = Terminal:new({ cmd = 'yazi', hidden = true })
vim.keymap.set('n', '<leader>ty', function() yazi:toggle() end, { desc = 'Open yazi [toggleterm]' })

local btop = Terminal:new({ cmd = 'btop', hidden = true })
vim.keymap.set('n', '<leader>tb', function() btop:toggle() end, { desc = 'Open btop [toggleterm]' })
