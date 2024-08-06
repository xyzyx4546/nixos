vim.o.clipboard = 'unnamedplus'

vim.o.number = true
vim.o.relativenumber = true

vim.o.signcolumn = 'yes'

vim.o.updatetime = 300

vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2

vim.cmd('colorscheme dracula')
vim.cmd [[
  highlight LspReferenceText guibg=#44475a guifg=#f8f8f2
  highlight LspReferenceRead guibg=#44475a guifg=#f8f8f2
  highlight LspReferenceWrite guibg=#44475a guifg=#f8f8f2
]]
vim.o.termguicolors = true
vim.api.nvim_command('autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE | hi SignColumn guibg=NONE ctermbg=NONE')
vim.opt.fillchars = { eob = " " }

vim.api.nvim_create_augroup('CreateMissingDirs', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
  group = 'CreateMissingDirs',
  pattern = '*',
  callback = function()
    vim.fn.mkdir(vim.fn.expand('<afile>:p:h'), 'p')
  end,
})

vim.o.mouse = 'a'
