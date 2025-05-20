vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.keymap.set('n', '<C-e>', '<cmd>NvimTreeToggle<CR>', { noremap = true, silent = true })

local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  local opts = { buffer = bufnr, noremap = true, silent = true, nowait = true }

  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.set('n', '<C-e>', api.tree.close, opts)
  vim.keymap.set('n', '<C-h>', api.tree.toggle_hidden_filter, opts)
  vim.keymap.set('n', '<C-i>', api.tree.toggle_gitignore_filter, opts)
  vim.keymap.set('n', '<C-j>', api.node.navigate.sibling.last, opts)
  vim.keymap.set('n', '<C-k>', api.node.navigate.sibling.first, opts)
  vim.keymap.set('n', '?', api.tree.toggle_help, opts)
  vim.keymap.set('n', 'l', api.node.open.edit, opts)

  vim.keymap.del('n', 'H', opts)
  vim.keymap.del('n', 'J', opts)
  vim.keymap.del('n', 'K', opts)
  vim.keymap.del('n', 'L', opts)
  vim.keymap.del('n', '<C-t>', opts)
end

require('nvim-tree').setup {
  on_attach = on_attach,
  hijack_cursor = true,
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
  view = {
    width = 30,
    side = 'right',
  },
  renderer = {
    highlight_git = true,
    root_folder_modifier = ':t',
    icons = {
      glyphs = {
        default = '',
        symlink = '',
        git = {
          unstaged = '',
          staged = 'S',
          unmerged = '',
          renamed = '➜',
          deleted = '',
          untracked = 'U',
          ignored = '◌',
        },
        folder = {
          default = '󰉋',
          open = '󰝰',
          empty = '󰉖',
          empty_open = '󰷏',
          symlink = '',
        },
      }
    }
  },
  update_focused_file = {
    enable = true,
    update_root = true
  },
  git = {
    enable = true,
    show_on_dirs = true,
    show_on_open_dirs = false,
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    show_on_open_dirs = false,
  },
  modified = {
    enable = true,
    show_on_dirs = true,
    show_on_open_dirs = false,
  },
  filters = {
    git_ignored = true,
    dotfiles = true,
  },
  ui = {
    confirm = {
      default_yes = true
    },
  },
}
