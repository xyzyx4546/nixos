require('telescope').setup({
  defaults = {
    prompt_prefix = " ",
    selection_caret = " ",
    mappings = {
      i = { ['<esc>'] = require('telescope.actions').close }
    },
  },

	extensions = {
    	fzf = {
      	fuzzy = true,
      	override_generic_sorter = true,
      	override_file_sorter = true,
      	case_mode = "smart_case",
    	}
  	}
})

require('telescope').load_extension('fzf')
require('telescope').load_extension('ui-select')

vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files theme=dropdown previewer=false<cr>')
